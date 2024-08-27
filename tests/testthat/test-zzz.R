test_that("the functions work", {
  expect_equal(p_cpma(0.05, 0.05), 0.05798245, tolerance = 1E-5)
  expect_equal(p_fct(0.05, 0.05), 0.01747866, tolerance = 1E-5)
  expect_equal(p_sumrank(0.05, 0.05), 0.005, tolerance = 1E-5)
})

test_that("the functions fail when needed", {
  expect_error(p_cpma(c(1, 1), 0.05))
  expect_error(p_fct(c(1, 1), 0.05))
  expect_error(p_sumrank(c(1, 1), 0.05))
})
