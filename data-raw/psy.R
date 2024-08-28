library(usethis)

# anx
anx <- data.frame(
  SNP = c("rs1", "rs2", "rs3", "rs4", "rs5", "rs6", "rs7"),
  A1  = c("T", "G", "C", "G", "G", "C", "A"),
  A2  = c("G", "A", "A", "A", "T", "T", "C"),
  Z   = c(0.39, -1.15, -1.52, 1.03, 4.22, -0.61, -1.59)
)
anx$P <- 2 * pnorm(-abs(anx$Z))
anx$N <- rep(25000, 7)

# bip
bip <- data.frame(
  SNP = c("rs3", "rs4", "rs5", "rs6", "rs7", "rs8", "rs9", "rs10"),
  A1  = c("C", "G", "G", "C", "A", "A", "C", "T"),
  A2  = c("A", "A", "T", "T", "C", "G", "T", "C"),
  Z   = c(-0.25, 1.5, 3.88, 1.5, -3.73, 0.01, 2.42, -0.41)
)

bip$P <- 2 * pnorm(-abs(bip$Z))
bip$N <- rep(45000, 8)

# dep
dep <- data.frame(
  SNP = c("rs1", "rs2", "rs3", "rs4", "rs5", "rs6", "rs7"),
  A1  = c("T", "G", "C", "G", "G", "C", "A"),
  A2  = c("G", "A", "A", "A", "T", "T", "C"),
  Z   = c(0.51, 0.66, 0.65, 1.4, 3.22, 0.82, 1.69)
)

dep$P <- 2 * pnorm(-abs(dep$Z))
dep$N <- rep(120000, 7)

# scz
scz <- data.frame(
  SNP = c("rs3", "rs4", "rs5", "rs6", "rs7", "rs8", "rs9", "rs10"),
  A1  = c("C", "G", "G", "C", "A", "A", "C", "T"),
  A2  = c("A", "A", "T", "T", "C", "G", "T", "C"),
  Z   = c(-1.2, -1.2, 4.91, -0.11, -4.18, -0.06, 0.12, -1.25)
)

scz$P <- 2 * pnorm(-abs(scz$Z))
scz$N <- rep(80000, 8)

# write
usethis::use_data(anx, bip, dep, scz, overwrite = TRUE)
