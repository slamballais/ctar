make_final <- function(l) {
  final <- list()
  final$p <- rep(NA, l[1])
  final$n <- rep(NA, l[1])
  final$traits <- vector(mode = "list", length = l[1])
  final$p_exp <- rep(NA, l[1])
  return(final)
}
