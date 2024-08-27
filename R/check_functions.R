check_cores <- function(n_cores) {
  if (!is.numeric(n_cores)) stop("`n_cores` should be a number")
  if (is.na(n_cores)) stop("`n_cores` is NA")
  if (is.nan(n_cores)) stop("`n_cores` is NaN")
  if (is.null(n_cores)) stop("`n_cores` is NULL")
  if (is.infinite(n_cores)) stop("`n_cores` is infinite")
  if (n_cores != as.integer(n_cores)) stop("`n_cores` should be an integer")
  if (n_cores < 1) stop("`n_cores` should be at least 1")
  mc <- parallel::detectCores()
  if (n_cores > mc) stop(mc, " cores detected, `n_cores` should be lower")
}

check_p <- function(p, maxval, two_traits = FALSE) {
  if (!is.list(p)) stop("`p` needs to be a list.")
  m <- length(p)
  if (m < 2) stop("`p` should have at least 2 elements (i.e., multiple p-value vectors).")
  l <- sapply(p, length)
  if (any(l != l[1])) stop("Not all elements of `p` are equally long.")
  p <- do.call("cbind", p)
  if (any(p < 0)) stop("Negative p-values detected, which is not possible.")
  if (any(p == 0))
    stop("At least 1 p-value is equal to 0; please replace with a very small value.")
  if (any(p > 1)) stop("P-values larger than 1 detected, which is not possible.")
  if (maxval > 1 || maxval <= 0)
    stop("Argument `maxval` should fall in the range (0,1].")
  p[p > maxval] <- 1
  out <- list(number_of_traits = m,
              number_of_snps = l,
              p_matrix = p)
  return(out)
}

check_z <- function(z, z_var = NULL, two_traits = FALSE) {
  if (!is.list(z)) stop("`z` needs to be a list.")
  m <- length(z)
  if (two_traits && m != 2) stop("`z` should have 2 elements (i.e., two z-value vectors")
  if (m < 2) stop("`z` should have at least 2 elements (i.e., multiple z-value vectors)")
  if (any(!sapply(z, is.numeric))) stop("all values of `z` should be numeric")
  if (any(sapply(z, function(x) any(is.na(x))))) stop("NAs found in z")
  if (any(sapply(z, function(x) any(is.nan(x))))) stop("NaNs found in z")
  if (any(sapply(z, is.null))) stop("NULLs found in z")
  l <- sapply(z, length)
  if (any(l != l[1])) stop("Not all elements of `z` are equally long.")

  if (is.null(z_var) && (l[1] == 1))
    stop("Only 1 variant supplied, but no `z_var` specified")
  if (!is.null(z_var)) {
    if (!is.numeric(z_var)) stop("`z_var` needs to be a numeric vector.")
    if (length(z_var) != m) stop("`z_var` should be as long as the number of traits")
    if (any(z_var < 0)) stop("`z_var` should contain positive numbers")
  }

  return(invisible())
}
