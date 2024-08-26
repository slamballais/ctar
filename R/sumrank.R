#' Run SumRank
#'
#' Run SumRank on p-values from GWAS summary stats
#'
#' This function allows you to run the SumRank method given a variety of parameters.
#'
#' @param p_in test
#' @param fixed_names test
#' @param .THRESHOLD test
#' @param .MAXVAL test
#' @param .FIXED test
#' @export

sumrank <- function(p_in, fixed_names = NULL, .THRESHOLD = 5E-8, .MAXVAL = 1, .FIXED = TRUE) {

  # check input arguments
  p_in_args <- check_p_in(p_in, .MAXVAL)
  m <- p_in_args$number_of_traits
  l <- p_in_args$number_of_snps
  p <- p_in_args$p_matrix

  if (!is.null(fixed_names) && is.null(pn <- names(p_in)))
    stop("`p_in` should be a named list; names are missing.")

  if (!is.numeric(.THRESHOLD) || .THRESHOLD < 0 || .THRESHOLD > 1)
    stop("Make sure `.THRESHOLD` is a number between 0 and 1")

  if (!is.logical(.FIXED)) stop("`.FIXED` should be `TRUE` or `FALSE`")

  # prep fixed_names
  if (!is.null(fixed_names)) {
    if (!is.list(fixed_names)) stop("`fixed_names` needs to be a list, with every element representing a set of names from which at least 1 name must be included in the final result.")
    fn <- unlist(fixed_names)
    if (any(fxx <- !fn %in% pn)) stop("`fixed_names` contains names that are not found in the names of `p_in`: ", paste(fn[fxx], collapse = ", "))
    if (any(fxx <- duplicated(fn))) stop("`fixed_names` contains certain names multiple times: ", paste(unique(fn[fxx]), collapse = ", "))
  }

  # run
  loi <- 0
  final_p <- rep(NA, l[1])
  final_n <- rep(NA, l[1])
  final_traits <- vector(mode = "list", length = l[1])
  final_exp <- rep(NA, l[1])
  ms <- 1:m
  lgamma_values <- lgamma(ms + 1)
  for (i in seq_len(l[1])) {
    x <- p[i, ]

    o <- fastorder(x)
    if (!is.null(fixed_names)) {
      pnn <- pn[o$ix]
      opt_index <- o$ix[vapply(fixed_names, function(y) min(match(y, pnn)), integer(1))]
      loi <- length(opt_index)
      o$ix <- c(opt_index, o$ix[!o$ix %in% opt_index])
      o$x <- x[o$ix]
    }
    p_exp <- ms * log(cumsum(o$x)) - lgamma_values
    p2 <- exp(p_exp)

    # this prevents a single trait with a very low p-value being lower than the fixed names set
    n <- if (!is.null(fixed_names)) pmax(which.min(p2[loi:m]) + loi - 1, loi) else which.min(p2)
    p_out <- p2[n]
    p_exp_out <- p_exp[n]
    n2 <- if (p_out < .THRESHOLD) n else 0
    traits <- o$ix[seq_len(n2)]
    oo <- if (!is.null(fixed_names)) o$x[(loi + 1):m] else o$x
    nn <- sum(oo < .THRESHOLD) + loi

    # this makes sure that any p-value below .THRESHOLD is included in the final set;
    # this was introduced to prevent weird scenarios where subsets would be more significant
    # than adding those subthreshold p-values as well
    if (.FIXED && nn > n2) {
      n2 <- nn
      p_out <- p2[nn]
      p_exp_out <- p_exp[nn]
      traits <- o$ix[1:nn]
    }

    final_p[i] <- min(p_out, 1)
    final_n[i] <- n2
    final_traits[[i]] <- traits
    final_exp[i] <- -p_exp_out / log(10)
  }

  final <- list(p = final_p, n = final_n, traits = final_traits, p_exp = final_exp)
  return(final)
}
