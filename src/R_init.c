#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

// Declaration
SEXP fastorder(SEXP x);

// Register routines
static const R_CallMethodDef CallEntries[] = {
  {"fastorder", (DL_FUNC) &fastorder, 1},
  {NULL, NULL, 0}
};

void R_init(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
