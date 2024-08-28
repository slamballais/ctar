#' @useDynLib ctar
#' @importFrom Rcpp sourceCpp
NULL

#' @name fastorder
#' @title Sort ordering numeric vectors
#' @description
#' Order a numeric vector in ascending order. Identical values are ordered in
#' descending order of occurrence.
#' @param x numeric vector.
#' @return \code{fastorder} returns a list with two elements:
#' \itemize{
#'   \item \code{x}: numeric vector. The ordered version of the vector.
#'   \item \code{ix}: numeric vector. The corresponding indices.
#' }
#' @examples
#' out <- fastorder(mtcars$cyl)
#' @export
fastorder <- function(x) {
  .Call("fastorder", x, PACKAGE = "ctar")
}

#' @examples
#' p <- replicate(10, runif(100), simplify = FALSE)
#' out <- sumrank(p)
#' @export
