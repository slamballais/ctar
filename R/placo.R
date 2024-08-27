#' Run PLACO
#'
#' Run PLACO on z-values from GWAS summary stats
#'
#' This function lets you to run the PLACO method given a variety of parameters.
#' Code heavily borrowed from Debashree Ray and Nilanjan Chatterjee.
#' https://github.com/RayDebashree/PLACO
#' https://doi.org/10.1371/journal.pgen.1009218
#'
#'
#' @param z test
#' @param z_var test
#' @param n_cores test
#' @importFrom stats sd
#' @importFrom stats integrate
#' @export

placo <- function(z, z_var = NULL, n_cores = 1) {

  check_z(z, z_var)
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
    parallel::clusterExport(cl, "pdfx")
    out <- 2 * parallel::parSapply(cl, zz, integrate_bessel)
  }
  return(out)
}

pdfx <- function(x) besselK(x = abs(x), nu = 0)/pi

integrate_bessel <- function(x)
  integrate(pdfx, x, Inf, abs.tol = .Machine$double.eps)$value
