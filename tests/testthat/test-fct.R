# default behavior
p_2 <- list(0.05, 0.05)
p_10 <- as.list(rep(0.05, 10))

test_that("fct works for two p-values", {
  expect_equal(fct(p_2)$p, 0.01747866, tolerance = 1E-5)
  expect_equal(fct(p_2)$n, 0)
})

test_that("fct works for ten p-values", {
  expect_equal(fct(p_10)$p, 7.341634e-06, tolerance = 1E-5)
  expect_equal(fct(p_10)$n, 0)
})

# handling exceptions
p_na <- list(0.05, NA)
p_null <- list(0.05, NULL)
p_nan <- list(0.05, NaN)
p_neg <- list(-0.05, -0.05)
p_char <- list(0.05, "test")

test_that("fct can deal with illogical values", {
  expect_error(fct(p_na))
  expect_error(fct(p_null))
  expect_error(fct(p_nan))
  expect_error(fct(p_neg))
  expect_error(fct(p_char))
})
