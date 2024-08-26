# default behavior
p_2 <- list(0.05, 0.05)
p_10 <- as.list(rep(0.05, 10))

test_that("cpma works for two p-values", {
  expect_equal(cpma(p_2)$p, 0.05798245, tolerance = 1E-5)
  expect_equal(cpma(p_2)$n, 0)
  expect_equal(cpma(p_2)$p_exp, -log10(0.05798245), tolerance = 1E-5)
})

test_that("cpma works for ten p-values", {
  expect_equal(cpma(p_10)$p, 2.243116e-05, tolerance = 1E-5)
  expect_equal(cpma(p_10)$n, 0)
  expect_equal(cpma(p_10)$p_exp, -log10(2.243116e-05), tolerance = 1E-5)
})

# handling exceptions
p_na <- list(0.05, NA)
p_null <- list(0.05, NULL)
p_nan <- list(0.05, NaN)
p_neg <- list(-0.05, -0.05)
p_char <- list(0.05, "test")

test_that("cpma can deal with illogical values", {
  expect_error(cpma(p_na))
  expect_error(cpma(p_null))
  expect_error(cpma(p_nan))
  expect_error(cpma(p_neg))
  expect_error(cpma(p_char))

  expect_error(cpma(p_2, epsilon = "test"))
  expect_error(cpma(p_2, epsilon = -1))
  expect_error(cpma(p_2, epsilon = 2))

  expect_error(cpma(p_2, .THRESHOLD = "test"))
  expect_error(cpma(p_2, .THRESHOLD = -1))
  expect_error(cpma(p_2, .THRESHOLD = 2))

  expect_error(cpma(p_2, .MAXVAL = "test"))
  expect_error(cpma(p_2, .MAXVAL = -1))
  expect_error(cpma(p_2, .MAXVAL = 2))
})

# handling extreme values
p_0 <- list()
p_1 <- list(0.05)

test_that("cpma can deal with extreme values", {
  expect_error(cpma(p_0))
  expect_error(cpma(p_1))
})
