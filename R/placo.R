#' @name placo
#' @title Run PLACO on z-scores
#' @description
#' This function allows you to run the PLACO method on z-scores from GWAS
#' summary statistics, given a variety of parameters. The code for this function
#' is heavily borrowed from the original PLACO function as written by Debashree
#' Jay and Nilanjan Chatterjee (https://github.com/RayDebashree/PLACO).
#' @param z list of numeric vectors. Contains the z-scores from each GWAS.
#' @param z_var numeric vector. Contains the variances of each \code{z} element.
#' @param n_cores integer (default: 1). Number of cores to be used.
#' @return Returns a numeric vector containing the p-values from PLACO.
#' @examples
#' z <- list(c(1, 1.1), c(1, 1.3))
#' z_var <- c(0.95, 0.97)
#' out <- placo(z, z_var)
#' @importFrom stats sd
#' @importFrom stats integrate
#' @export

placo <- function(z, z_var = NULL, n_cores = 1) {

  check_z(z, z_var, two_traits = TRUE)
  check_cores(n_cores)

  if (is.null(z_var)) z_var <- c(sd(z[[1]]), sd(z[[2]]))
  z12 <- abs(z[[1]] * z[[2]])
  z12_s1 <- z12 / z_var[1]
  z12_s2 <- z12 / z_var[2]
  p1 <- parallel_placo(z12_s1, n_cores)
  p2 <- parallel_placo(z12_s2, n_cores)
  p0 <- parallel_placo(z12, n_cores)
  return(p1 + p2 - p0)
}

parallel_placo <- function(zz, n_cores) {
  if (n_cores == 1) {
    out <- 2 * sapply(zz, integrate_bessel)
  } else {
    cl <- parallel::makeCluster(n_cores)
    doParallel::registerDoParallel(cl)
    on.exit(parallel::stopCluster(cl))
    parallel::clusterExport(cl, "besselK")
    out <- 2 *
      parallel::parSapply(cl, zz, integrate_bessel)
  }
  return(out)
}

integrate_bessel <- function(x) {
  integrate(function(y) besselK(x = abs(y), nu = 0) / pi,
            x,
            Inf,
            abs.tol = .Machine$double.eps)$value
}
