placo <- function(z1, z2, var_1 = NULL, var_2 = NULL, n_cores = 1) {
  if (is.null(var_1)) var_1 <- sd(z1)
  if (is.null(var_2)) var_1 <- sd(z2)
  z12 <- abs(z1 * z2)
  z12_s1 <- z12 / var_1
  z12_s2 <- z12 / var_2
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
    parallel::clusterExport(cl, ".pdfx")
    out <- 2 * parallel::parSapply(cl, zz, integrate_bessel)
  }
  return(out)
}

.pdfx <- function(x) besselK(x = abs(x), nu = 0)/pi
integrate_bessel <- function(x) integrate(.pdfx, x, Inf, abs.tol = .Machine$double.eps)$value
