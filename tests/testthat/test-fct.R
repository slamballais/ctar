# default behavior
p_2 <- list(0.05, 0.05)
p_10 <- as.list(rep(0.05, 10))
p_ns <- as.list(rep(5E-8, 10))

test_that("fct works for two p-values", {
  expect_equal(fct(p_2)$p, 0.01747866, tolerance = 1E-5)
  expect_equal(fct(p_2)$n, 0)
  expect_equal(fct(p_2)$p_exp, -log10(0.01747866), tolerance = 1E-5)
})

test_that("fct works for ten p-values", {
  expect_equal(fct(p_10)$p, 7.341634e-06, tolerance = 1E-5)
  expect_equal(fct(p_10)$n, 0)
  expect_equal(fct(p_10)$p_exp, -log10(7.341634e-06), tolerance = 1E-5)
})

test_that("fct works the same as non-subset fct", {
  expect_equal(fct(p_2)$p, do.call("p_fct", p_2))
  expect_equal(fct(p_ns)$p, do.call("p_fct", p_ns))
})

test_that("the fixed argument works", {
  expect_equal(fct(list(0.99, 5E-8), p_threshold = 1)$n, 2)
  expect_equal(fct(list(0.99, 5E-8), p_threshold = 1, fixed = FALSE)$n, 1)
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

  expect_error(fct(p_2, p_threshold = "test"))
  expect_error(fct(p_2, p_threshold = -1))
  expect_error(fct(p_2, p_threshold = 2))

  expect_error(fct(p_2, maxval = "test"))
  expect_error(fct(p_2, maxval = -1))
  expect_error(fct(p_2, maxval = 2))

  expect_error(fct(p_2, fixed = "test"))
  expect_error(fct(p_2, fixed = -1))
  expect_error(fct(p_2, fixed = 2))
})

# handling extreme values
p_0 <- list()
p_1 <- list(0.05)
p_10k <- as.list(rep(0.3, 10000))

test_that("fct can deal with extreme values", {
  expect_error(fct(p_0))
  expect_error(fct(p_1))
  expect_equal(fct(p_10k)$p, 4.113606e-82, tolerance = 1E-5)
})
