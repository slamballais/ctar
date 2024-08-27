# default behavior
v_2 <- c(1, 1)

test_that("placo works for two z values", {
  expect_equal(placo(list(2, 2),     v_2), 0.0064596, tolerance = 1E-5)
  expect_equal(placo(list(-2, -2),   v_2), 0.0064596, tolerance = 1E-5)
  expect_equal(placo(list(0, 0),     v_2), 0.99999, tolerance = 1E-5)
  expect_equal(placo(list(10, 10),   v_2), 2.949898e-45)
  expect_equal(placo(list(100, 100), v_2), 0)
})

# handling exceptions
test_that("placo can deal with illogical values", {
  expect_error(placo(list(2, NA),   v_2))
  expect_error(placo(list(2, NULL), v_2))
  expect_error(placo(list(2, NaN),  v_2))
  expect_error(placo(list(2, "2"),  v_2))
})
