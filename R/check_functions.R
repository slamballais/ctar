check_cores <- function(n_cores) {
  if (!is.numeric(n_cores)) stop("`n_cores` should be a number")
  if (n_cores != as.integer(n_cores)) stop("`n_cores` should be an integer")
  if (is.na(n_cores)) stop("`n_cores` is NA")
  if (is.nan(n_cores)) stop("`n_cores` is NaN")
  if (is.null(n_cores)) stop("`n_cores` is NULL")
  if (is.infinite(n_cores)) stop("`n_cores` is infinite")
  if (n_cores < 1) stop("`n_cores` should be at least 1")
  mc <- parallel::detectCores()
  if (n_cores > mc) stop(mc, " cores detected, `n_cores` should be lower")
}

check_p_in <- function(p_in, .MAXVAL) {
  if (!is.list(p_in)) stop("`p_in` needs to be a list.")
  m <- length(p_in)
  if (m < 2) stop("`p_in` should have at least 2 elements (i.e., multiple p-value vectors).")
  l <- sapply(p_in, length)
  if (any(l != l[1])) stop("Not all elements of `p_in` are equally long.")
  p <- do.call("cbind", p_in)
  if (any(p < 0)) stop("Negative p-values detected, which is not possible.")
  if (any(p > 1)) stop("P-values larger than 1 detected, which is not possible.")
  if (.MAXVAL > 1 || .MAXVAL <= 0)
    stop("Argument `.MAXVAL` should fall in the range (0,1].")
  p[p > .MAXVAL] <- 1
  out <- list(number_of_traits = m,
              number_of_snps = l,
              p_matrix = p)
  return(out)
}

check_z <- function(z_1, z_2, var_1, var_2) {
  if (!is.numeric(z_1)) stop("`z_1` should be numeric")
  if (!is.numeric(z_2)) stop("`z_2` should be numeric")

  if (any(is.na(z_1))) stop("NAs found in `z_1`")
  if (any(is.nan(z_1))) stop("NaNs found in `z_1`")
  if (is.null(z_1)) stop("`z_1` is NULL")
  if (any(is.na(z_2))) stop("NAs found in `z_2`")
  if (any(is.nan(z_2))) stop("NaNs found in `z_2`")
  if (is.null(z_2)) stop("`z_2` is NULL")

  if (length(z_1) != length(z_2)) stop("`z_1` and `z_2` have different lengths")

  if (!is.null(var_1)) {
    if (!is.numeric(var_1)) stop("`var_1` should be numeric")
    if (length(var_1) > 1) stop("`var_1` should be a single number")
    if (var_1 < 0) stop("`var_1` should be a positive number")
  }

  if (!is.null(var_2)) {
    if (!is.numeric(var_2)) stop("`var_2` should be numeric")
    if (length(var_2) > 1) stop("`var_2` should be a single number")
    if (var_2 < 0) stop("`var_2` should be a positive number")
  }

  return(NULL)
}
