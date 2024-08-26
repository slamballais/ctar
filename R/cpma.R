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

  # prep p_in
  if (!is.list(p_in)) stop("`p_in` needs to be a list.")
  m <- length(p_in)
  if (m < 2) stop("`p_in` should have at least 2 elements (i.e., multiple p-value vectors).")
  l <- sapply(p_in, length)
  if (any(l != l[1])) stop("Not all elements of `p_in` are equally long.")
  p <- do.call("cbind", p_in)
  if (any(p < 0)) stop("Negative p-values detected, which is not possible.")
  p[p > .MAXVAL] <- 1

  # run
  loi <- 0
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

    final_p[i] <- p_out
    final_n[i] <- n2
    final_traits[[i]] <- traits
  }

  final <- list(p = pmin(final_p, 1), n = final_n, traits = final_traits)
  return(final)
}
