# default behavior
p_2 <- list(0.05, 0.05)
p_10 <- as.list(rep(0.05, 10))

test_that("SumRank works for two p-values", {
  expect_equal(sumrank(p_2)$p, 0.005)
  expect_equal(sumrank(p_2)$n, 0)
  expect_equal(sumrank(p_2)$p_exp, -log10(0.005))
})

test_that("SumRank works for ten p-values", {
  expect_equal(sumrank(p_10)$p, 2.691144e-10)
  expect_equal(sumrank(p_10)$n, 10)
  expect_equal(sumrank(p_10)$p_exp, -log10(2.691144e-10))
})

# handling exceptions
p_na <- list(0.05, NA)
p_null <- list(0.05, NULL)
p_nan <- list(0.05, NaN)
p_neg <- list(-0.05, -0.05)
p_char <- list(0.05, "test")

test_that("SumRank can deal with illogical values", {
  expect_error(sumrank(p_na))
  expect_error(sumrank(p_null))
  expect_error(sumrank(p_nan))
  expect_error(sumrank(p_neg))
  expect_error(sumrank(p_char))
})

# handling extreme values
p_0 <- list()
p_1 <- list(0.05)
p_10k <- as.list(rep(0.00001, 10000))
p_small <- list(5E-300, 5E-300)

test_that("SumRank can deal with extreme values", {
  expect_error(sumrank(p_0))
  expect_error(sumrank(p_1))
  expect_equal(sumrank(p_10k)$n, 10000)
  expect_equal(sumrank(p_small)$p_exp, 598.30103)
})

