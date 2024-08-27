#' Run CPMA
#'
#' Run CPMA on p-values from GWAS summary stats
#'
#' This function allows you to run the cross-phenotype meta-analysis (CPMA)
#' method given a variety of parameters.
#'
#' @param p test
#' @param epsilon test
#' @param p_threshold test
#' @param maxval test
#' @param fixed test
#' @importFrom stats pchisq
#' @export

cpma <- function(p,
                 epsilon = 0.001,
                 p_threshold = 5E-8,
                 maxval = 1,
                 fixed = TRUE) {

  # check input arguments
  p_args <- check_p(p, maxval)
  m <- p_args$number_of_traits
  l <- p_args$number_of_snps
  pm <- p_args$p_matrix

  if (!is.numeric(epsilon) || epsilon < 0 || epsilon > 1)
    stop("Make sure `epsilon` is a number between 0 and 1")

  if (!is.numeric(p_threshold) || p_threshold < 0 || p_threshold > 1)
    stop("Make sure `p_threshold` is a number between 0 and 1")

  if (!is.logical(fixed)) stop("`fixed` should be `TRUE` or `FALSE`")

  # run
  final <- make_final(l)
  for (i in seq_len(l[1])) {
    x <- pm[i, ]
    o <- fastorder(x)
    ms <- 1 / (cumsum(-log(o$x)) / 1:m)
    an <- -log(o$x) - epsilon
    ap <- -log(o$x) + epsilon
    oo <- sapply(1:m, function(i) sum(log(exp(an[1:i] * -ms[i]) - exp(ap[1:i] * -ms[i]))))
    ee <- sapply(1:m, function(i) sum(log(exp(-an[1:i]) - exp(-ap[1:i]))))
    p2 <- pchisq(abs(oo - ee) * 2, 1, lower.tail = FALSE)
    p3 <- min(p2)
    n <- which.min(p2)
    n2 <- if (p3 < p_threshold) n else 0
    traits <- o$ix[seq_len(n2)]
    p_out <- p2[n]

    nn <- sum(o$x < p_threshold)
    if (fixed && nn > n2) {
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
