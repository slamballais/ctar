#' Run SumRank
#'
#' Run SumRank on p-values from GWAS summary stats
#'
#' This function allows you to run the SumRank method
#' given a variety of parameters.
#'
#' @param p test
#' @param fixed_names test
#' @param p_threshold test
#' @param maxval test
#' @param fixed test
#' @export

sumrank <- function(p,
                    fixed_names = NULL,
                    p_threshold = 5E-8,
                    maxval = 1,
                    fixed = TRUE) {

  # check input arguments
  p_args <- check_p(p, maxval)
  m <- p_args$number_of_traits
  l <- p_args$number_of_snps
  pm <- p_args$p_matrix

  if (!is.null(fixed_names) && is.null(pn <- names(p)))
    stop("`p` should be a named list; names are missing.")

  if (!is.numeric(p_threshold) || p_threshold < 0 || p_threshold > 1)
    stop("Make sure `p_threshold` is a number between 0 and 1")

  if (!is.logical(fixed)) stop("`fixed` should be `TRUE` or `FALSE`")

  # prep fixed_names
  if (!is.null(fixed_names)) {
    if (!is.list(fixed_names))
      stop("`fixed_names` needs to be a list, with every element ",
           "representing a set of names from which at least 1 name must ",
           "be included in the final result.")
    fn <- unlist(fixed_names)
    if (any(fxx <- !fn %in% pn))
      stop("`fixed_names` contains names that are not found in ",
           "the names of `p`: ", paste(fn[fxx], collapse = ", "))
    if (any(fxx <- duplicated(fn)))
      stop("`fixed_names` contains certain names multiple times: ",
           paste(unique(fn[fxx]), collapse = ", "))
  }

  # run
  final <- make_final(l)
  loi <- 0
  ms <- 1:m
  lgamma_values <- lgamma(ms + 1)
  for (i in seq_len(l[1])) {
    x <- pm[i, ]

    o <- fastorder(x)
    if (!is.null(fixed_names)) {
      pnn <- pn[o$ix]
      opt_i <- vapply(fixed_names, function(y) min(match(y, pnn)), integer(1))
      opt_index <- o$ix[opt_i]
      loi <- length(opt_index)
      new_ix <- o$ix[!o$ix %in% opt_index]
      o$ix <- c(opt_index, new_ix)
      o$x <- x[o$ix]
    }
    p_exp <- ms * log(cumsum(o$x)) - lgamma_values
    p2 <- exp(p_exp)

    # this prevents a single trait with a very low p-value being
    # lower than the fixed names set
    if (!is.null(fixed_names)) {
      tmp_low <- which.min(p2[loi:m])
      n <- pmax(tmp_low + loi - 1, loi)
    } else {
      n <- which.min(p2)
    }
    p_out <- p2[n]
    p_exp_out <- p_exp[n]
    n2 <- if (p_out < p_threshold) {
      n
    } else {
      0
    }
    traits <- o$ix[seq_len(n2)]
    oo <- if (!is.null(fixed_names)) {
      o$x[(loi + 1):m]
    } else {
      o$x
    }
    nn <- sum(oo < p_threshold) + loi

    # this makes sure that any p-value below p_threshold is included in
    # the final set; this was introduced to prevent weird scenarios where
    # subsets would be more significant than adding those subthreshold
    # p-values as well
    if (fixed && nn > n2) {
      n2 <- nn
      p_out <- p2[nn]
      p_exp_out <- p_exp[nn]
      traits <- o$ix[1:nn]
    }

    final$p[i] <- min(p_out, 1)
    final$n[i] <- n2
    final$traits[[i]] <- traits
    final$p_exp[i] <- -p_exp_out / log(10)
  }
  return(final)
}
