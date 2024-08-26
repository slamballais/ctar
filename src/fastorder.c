#include <R.h>
#include <Rinternals.h>

// Define a threshold for switching to insertion sort
#define INSERTION_SORT_THRESHOLD 10

// Insertion sort for small arrays
static void insertion_sort(double *array, int *indices, int low, int high) {
  for (int i = low + 1; i <= high; i++) {
    double key = array[indices[i]];
    int keyIndex = indices[i];
    int j = i - 1;
    while (j >= low && array[indices[j]] > key) {
      indices[j + 1] = indices[j];
      j--;
    }
    indices[j + 1] = keyIndex;
  }
}

// Optimized quicksort function
static void quicksort(double *array, int *indices, int low, int high) {
  if (high - low < INSERTION_SORT_THRESHOLD) {
    insertion_sort(array, indices, low, high);
    return;
  }

  if (low < high) {
    int pivotIndex = (low + high) / 2;
    double pivotValue = array[indices[pivotIndex]];
    int i = low, j = high;

    // Move elements around pivot
    while (i <= j) {
      while (array[indices[i]] < pivotValue) i++;
      while (array[indices[j]] > pivotValue) j--;
      if (i <= j) {
        // Swap indices
        int temp = indices[i];
        indices[i] = indices[j];
        indices[j] = temp;
        i++;
        j--;
      }
    }

    // Recursively sort the partitions
    if (low < j) quicksort(array, indices, low, j);
    if (i < high) quicksort(array, indices, i, high);
  }
}

// R wrapper function
SEXP fastorder(SEXP x) {
  // Check if x is numeric and convert to REALSXP if necessary
  if (!isNumeric(x)) {
    error("Argument is not a numeric vector");
  }

  SEXP sx = PROTECT(coerceVector(x, REALSXP));
  R_xlen_t n = XLENGTH(sx);
  double *array = REAL(sx);
  int *indices = (int *) R_alloc(n, sizeof(int));

  // Initialize indices
  for (R_xlen_t i = 0; i < n; i++) {
    indices[i] = i;
  }

  // Sort indices
  quicksort(array, indices, 0, n - 1);

  // Create sorted vector
  SEXP sorted = PROTECT(allocVector(REALSXP, n));
  double *sorted_array = REAL(sorted);
  for (R_xlen_t i = 0; i < n; i++) {
    sorted_array[i] = array[indices[i]];
  }

  // Create indices vector
  SEXP index_vector = PROTECT(allocVector(INTSXP, n));
  int *sorted_indices = INTEGER(index_vector);
  for (R_xlen_t i = 0; i < n; i++) {
    sorted_indices[i] = indices[i] + 1; // Convert to 1-based indexing
  }

  // Create names vector
  SEXP names = PROTECT(allocVector(STRSXP, 2));
  SET_STRING_ELT(names, 0, mkChar("x"));
  SET_STRING_ELT(names, 1, mkChar("ix"));

  // Create result list
  SEXP result = PROTECT(allocVector(VECSXP, 2));
  SET_VECTOR_ELT(result, 0, sorted);
  SET_VECTOR_ELT(result, 1, index_vector);
  setAttrib(result, R_NamesSymbol, names);

  UNPROTECT(5);
  return result;
}
