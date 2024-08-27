#' Non-subset functions
#'
#' Run non-subset versions of the various methods.
#'
#' These were added mostly to confirm that the subset versions are working properly.
#'
#' @param ... test
#' @param epsilon test
#' @importFrom stats pchisq
#' @export

p_cpma <- function(..., epsilon = 0.001) {
  args <- list(...)
  l <- sapply(args, length)
  if ( length(unique(l)) != 1) stop("Not all input vectors are equally long.")
  m <- length(args)

  argsL <- lapply(args, function(x) -log(x))
  ms <- 1 / (Reduce(`+`, argsL) / m)
  args2 <- do.call("rbind", argsL)
  id <- seq_len(ncol(args2))

  argsneg <- sweep(args2, 2, epsilon, `-`)
  argspos <- sweep(args2, 2, epsilon, `+`)

  o <- log(exp(sweep(argsneg, 2, -ms, `*`)) - exp(sweep(argspos, 2, -ms, `*`)))
  e <- log(exp(sweep(argsneg, 2, -1, `*`)) - exp(sweep(argspos, 2, -1, `*`)))

  os <- colSums(o)
  es <- colSums(e)

  stat <- -2 * (os - es)
  pchisq(abs(stat), 1, lower.tail = FALSE)

}

p_fct <- function(...) {
  args <- list(...)
  len <- sapply(args, length)
  if ( length(unique(len)) != 1) stop("Not all input vectors are equally long.")
  m <- length(args)
  logs <- lapply(args, log)
  X2 <- Reduce(`+`, logs) * -2
  pchisq(X2, df = m * 2, lower.tail = FALSE)
}

p_sumrank <- function(...) {
  args <- list(...)
  l <- sapply(args, length)
  if ( length(unique(l)) != 1) stop("Not all input vectors are equally long.")
  psum <- Reduce(`+`, args)
  m <- length(args)
  p <- 1 / factorial(m)
  out <- p * psum^m
  out[out > 1] <- 1
  return(out)
}

