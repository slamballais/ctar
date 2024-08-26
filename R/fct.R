#' Run FCT
#'
#' Run FCT on p-values from GWAS summary stats
#'
#' This function allows you to run the Fisher's combined probability test (FCT)
#' given a variety of parameters.
#'
#' @param p_in test
#' @param epsilon test
#' @param .THRESHOLD test
#' @param .MAXVAL test
#' @param .FIXED test
#' @export

fct <- function(p_in, .THRESHOLD = 5E-8, .MAXVAL = 1, .FIXED = TRUE) {

  # check input arguments
  p_in_args <- check_p_in(p_in, .MAXVAL)
  m <- p_in_args$number_of_traits
  l <- p_in_args$number_of_snps
  p <- p_in_args$p_matrix

  if (!is.numeric(.THRESHOLD) || .THRESHOLD < 0 || .THRESHOLD > 1)
    stop("Make sure `.THRESHOLD` is a number between 0 and 1")

  if (!is.logical(.FIXED)) stop("`.FIXED` should be `TRUE` or `FALSE`")

  # run
  final <- make_final(l)

  for (i in seq_len(l[1])) {
    x <- p[i, ]
    o <- fastorder(x)
    p2 <- pchisq(cumsum(log(o$x)) * -2, df = 1:m * 2, lower.tail = FALSE)
    p3 <- min(p2)
    n <- which.min(p2)
    n2 <- if (p3 < .THRESHOLD) n else 0
    traits <- o$ix[seq_len(n2)]
    p_out <- p2[n]

    nn <- sum(o$x < .THRESHOLD)
    if (.FIXED && nn > n2) {
      n2 <- nn
      p_out <- p2[nn]
      traits <- o$ix[1:nn]
    }

    final$p[i] <- min(p_out, 1)
    final$n[i] <- n2
    final$traits[[i]] <- traits
    final$p_exp[i] <- -log10(final$p[i])
  }
  return(final)
}
