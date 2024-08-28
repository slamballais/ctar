#' @name check_cores
#' @family check_functions_from_ctar
#' @title Checking n_cores argument
#' @description
#' Checks the validity of the n_cores input argument that is used within the
#' \code{ctar} package.
#' @param n_cores integer. The number of cores to be used, for parallel
#' processing.
#' @return `NULL`, invisibly. The function is called for its side effects.
#' @examples
#' check_cores(1)
#' @export

check_cores <- function(n_cores) {
  if (!is.numeric(n_cores)) stop("`n_cores` should be a number")
  if (is.na(n_cores)) stop("`n_cores` is NA")
  if (is.infinite(n_cores)) stop("`n_cores` is infinite")
  if (n_cores != as.integer(n_cores)) stop("`n_cores` should be an integer")
  if (n_cores < 1) stop("`n_cores` should be at least 1")
  mc <- parallel::detectCores()
  if (n_cores > mc) stop(mc, " cores detected, `n_cores` should be lower")
  invisible()
}

#' @name check_p
#' @family check_functions_from_ctar
#' @title Checking \code{p} and \code{maxval} arguments
#' @description
#' Checks the validity of the \code{p} and \code{maxval} input arguments that
#' is used within the \code{ctar} package.
#' @param p list of numeric vectors. Contains the p-values from each GWAS.
#' @param maxval numeric scalar in range \eqn{(0, 1]} (default: 1).
#' The maximum value for p-values to be considered for analysis.
#' @param two_traits logical (default: FALSE). Is the call for two traits?
#' @return \code{check_p} returns a list with three elements:
#' \itemize{
#'   \item \code{number_of_traits}: The number of traits.
#'   \item \code{number_of_snps}: The number of SNPs.
#'   \item \code{p_matrix}: \code{p} as a matrix.
#' }
#' @examples
#' p <- list(c(0.01, 0.02), c(0.03, 0.04))
#' maxval <- 0.05
#' check_p(p, maxval)
#' @export

check_p <- function(p, maxval, two_traits = FALSE) {
  if (!is.list(p)) stop("`p` needs to be a list.")
  m <- length(p)
  if (m < 2)
    stop("`p` should have >=2 elements (i.e., multiple p-value vectors).")
  l <- sapply(p, length)
  if (any(l != l[1])) stop("Not all elements of `p` are equally long.")
  p <- do.call("cbind", p)
  if (any(p < 0)) stop("Negative p-values detected, which is not possible.")
  if (any(p == 0))
    stop("At least 1 p-value is 0; please replace with a very small value.")
  if (any(p > 1)) stop("P-values larger than 1 detected.")
  if (maxval > 1 || maxval <= 0)
    stop("Argument `maxval` should fall in the range (0,1].")
  p[p > maxval] <- 1
  out <- list(number_of_traits = m,
              number_of_snps = l,
              p_matrix = p)
  return(out)
}

#' @name check_z
#' @family check_functions_from_ctar
#' @title Checking \code{z} and \code{z_var} arguments
#' @description
#' Checks the validity of the \code{z} and \code{z_var} input arguments that
#' is used within the \code{ctar} package.
#' @param z list of numeric vectors. Contains the z-scores from each GWAS.
#' @param z_var numeric vector. Contains the variances of each element of
#' \code{z}.
#' @param two_traits logical (default: FALSE). Is the call for two traits?
#' @return `NULL`, invisibly. The function is called for its side effects.
#' @examples
#' z <- list(c(1, 1.1), c(1, 1.3))
#' z_var <- c(0.95, 0.97)
#' check_z(z, z_var, two_traits = TRUE)
#' @export

check_z <- function(z, z_var = NULL, two_traits = FALSE) {
  if (!is.list(z)) stop("`z` needs to be a list.")
  m <- length(z)
  if (two_traits && m != 2)
    stop("`z` should have 2 elements (i.e., two z-score vectors)")
  if (m < 2)
    stop("`z` should have at least 2 elements (i.e., multiple z-score vectors)")
  if (any(!sapply(z, is.numeric))) stop("all values of `z` should be numeric")
  if (any(sapply(z, function(x) any(is.na(x))))) stop("NAs found in z")
  l <- sapply(z, length)
  if (any(l != l[1])) stop("Not all elements of `z` are equally long.")

  if (is.null(z_var) && (l[1] == 1))
    stop("Only 1 variant supplied, but no `z_var` specified")
  if (!is.null(z_var)) {
    if (!is.numeric(z_var)) stop("`z_var` needs to be a numeric vector.")
    if (any(is.na(z_var))) stop("`z_var` should not contain NAs.")
    if (length(z_var) != m)
      stop("`z_var` should be as long as the number of traits")
    if (any(z_var < 0)) stop("`z_var` should contain positive numbers")
  }

  return(invisible())
}
