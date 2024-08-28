# default behavior
v_2 <- c(1, 1)
z_t <- list(c(2, 3), c(2, 3))

v_3 <- rep(1, 3)
z_3 <- list(c(1, 1), c(2, 2), c(3, 3))

test_that("placo works for two z values", {
  expect_equal(placo(list(2, 2),     v_2), 0.0064596, tolerance = 1E-5)
  expect_equal(placo(list(-2, -2),   v_2), 0.0064596, tolerance = 1E-5)
  expect_equal(placo(list(0, 0),     v_2), 0.99999, tolerance = 1E-5)
  expect_equal(placo(list(10, 10),   v_2), 2.949898e-45)
  expect_equal(placo(list(100, 100), v_2), 0)

  expect_equal(placo(z_t)[1], -4.322276e-03, tolerance = 1E-5)
  expect_equal(placo(list(2, 2), v_2, n_cores = 2), 0.0064596, tolerance = 1E-5)
})

# handling exceptions
test_that("placo can deal with illogical values", {
  expect_error()
  expect_error(placo(list(2, NA),   v_2))
  expect_error(placo(list(2, NULL), v_2))
  expect_error(placo(list(2, NaN),  v_2))
  expect_error(placo(list(2, "2"),  v_2))
  expect_error(placo(z_3,           v_3))
})
