#' @useDynLib ctar
#' @importFrom Rcpp sourceCpp
NULL

#' Sort Positive Floats and Return Indices
#'
#' This function sorts a numeric vector of positive floats and returns the sorted values and their original indices.
#'
#' @param x A numeric vector of positive floats.
#' @return A list with two elements: "x" and "ix".
#' @export
fastorder <- function(x) {
  .Call("fastorder", x, PACKAGE = "ctar")
}
