# check_p_in: handling exceptions
p_2 <- list(0.05, 0.05)
p_na <- list(0.05, NA)
p_null <- list(0.05, NULL)
p_nan <- list(0.05, NaN)
p_neg <- list(-0.05, -0.05)
p_high <- list(2, 2)
p_char <- list(0.05, "test")

test_that("`check_p_in` can deal with illogical values", {
  expect_error(check_p_in(p_na, 1))
  expect_error(check_p_in(p_null, 1))
  expect_error(check_p_in(p_nan, 1))
  expect_error(check_p_in(p_neg, 1))
  expect_error(check_p_in(p_high, 1))
  expect_error(check_p_in(p_char, 1))

  expect_error(check_p_in(p_2, -1))
  expect_error(check_p_in(p_2, 2))
  expect_error(check_p_in(p_2, "test"))
})

# check_cores: handling exceptions
test_that("`check_cores` can deal with illogical values", {
  expect_error(check_p_in(NA))
  expect_error(check_p_in(NaN))
  expect_error(check_p_in(NULL))
  expect_error(check_p_in(-5))
  expect_error(check_p_in(0))
  expect_error(check_p_in(1.1))
  expect_error(check_p_in(Inf))
})
