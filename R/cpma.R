#' Run CPMA
#'
#' Run CPMA on p-values from GWAS summary stats
#'
#' This function allows you to run the cross-phenotype meta-analysis (CPMA)
#' method given a variety of parameters.
#'
#' @param p_in test
#' @param epsilon test
#' @param .THRESHOLD test
#' @param .MAXVAL test
#' @param .FIXED test
#' @export

cpma <- function(p_in, epsilon = 0.001, .THRESHOLD = 5E-8, .MAXVAL = 1, .FIXED = TRUE) {

  # check input arguments
  p_in_args <- check_p_in(p_in, .MAXVAL)
  m <- p_in_args$number_of_traits
  l <- p_in_args$number_of_snps
  p <- p_in_args$p_matrix

  if (!is.numeric(epsilon) || epsilon < 0 || epsilon > 1)
    stop("Make sure `epsilon` is a number between 0 and 1")

  if (!is.numeric(.THRESHOLD) || .THRESHOLD < 0 || .THRESHOLD > 1)
    stop("Make sure `.THRESHOLD` is a number between 0 and 1")

  if (!is.logical(.FIXED)) stop("`.FIXED` should be `TRUE` or `FALSE`")

  # run
  final_p <- rep(NA, l[1])
  final_n <- rep(NA, l[1])
  final_traits <- vector(mode = "list", length = l[1])

  for (i in seq_len(l[1])) {
    x <- p[i, ]
    o <- fastorder(x)
    ms <- 1 / (cumsum(-log(o$x)) / 1:m)
    an <- -log(o$x) - epsilon
    ap <- -log(o$x) + epsilon
    oo <- sapply(1:m, function(i) sum(log(exp(an[1:i] * -ms[i]) - exp(ap[1:i] * -ms[i]))))
    ee <- sapply(1:m, function(i) sum(log(exp(-an[1:i]) - exp(-ap[1:i]))))
    p2 <- pchisq(abs(oo - ee) * 2, 1, lower.tail = FALSE)
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

    final_p[i] <- min(p_out, 1)
    final_n[i] <- n2
    final_traits[[i]] <- traits
  }

  final <- list(p = final_p, n = final_n, traits = final_traits)
  return(final)
}
