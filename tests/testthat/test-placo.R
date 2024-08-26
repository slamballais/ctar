# default behavior
test_that("placo works for two z values", {
  expect_equal(placo(2, 2, 1, 1), 0.0064596, tolerance = 1E-5)
  expect_equal(placo(-2, -2, 1, 1), 0.0064596, tolerance = 1E-5)
  expect_equal(placo(0, 0, 1, 1), 0.99999, tolerance = 1E-5)
  expect_equal(placo(10, 10, 1, 1), 2.949898e-45)
  expect_equal(placo(100, 100, 1, 1), 0)
})

# handling exceptions
test_that("placo can deal with illogical values", {
  expect_error(placo(2, NA, 1, 1))
  expect_error(placo(2, NULL, 1, 1))
  expect_error(placo(2, NaN, 1, 1))
  expect_error(placo(2, "2", 1, 1))
})
