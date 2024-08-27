# check_p: handling exceptions
p_2 <- list(0.05, 0.05)
p_na <- list(0.05, NA)
p_null <- list(0.05, NULL)
p_nan <- list(0.05, NaN)
p_neg <- list(-0.05, -0.05)
p_high <- list(2, 2)
p_char <- list(0.05, "test")
p_zero <- list(0.05, 0)

test_that("`check_p` can deal with illogical values", {
  expect_error(check_p(p_na, 1))
  expect_error(check_p(p_null, 1))
  expect_error(check_p(p_nan, 1))
  expect_error(check_p(p_neg, 1))
  expect_error(check_p(p_high, 1))
  expect_error(check_p(p_char, 1))
  expect_error(check_p(p_zero, 1))

  expect_error(check_p(p_2, -1))
  expect_error(check_p(p_2, 2))
  expect_error(check_p(p_2, "test"))
})

# check_cores: handling exceptions
test_that("`check_cores` can deal with illogical values", {
  expect_error(check_cores(NA))
  expect_error(check_cores(NaN))
  expect_error(check_cores(NULL))
  expect_error(check_cores(-5))
  expect_error(check_cores(0))
  expect_error(check_cores(1.1))
  expect_error(check_cores(Inf))
})

# check_z: handling exceptions
z_2 <- list(1, 2)
z_high <- list(300, 300)
z_na <- list(1, NA)
z_nan <- list(1, NaN)
z_null <- list(1, NULL)
z_char <- list(1, "char")
z_toofew <- list(1)
z_toomany <- list(1, 2, 3)
z_vec <- c(1, 2)

v_2 <- c(1, 2)
v_na <- c(1, NA)
v_nan <- c(1, NaN)
v_null <- c(1, NULL)
v_char <- c(1, "test")
v_toofew <- c(1)
v_toomany <- c(1, 2, 3)
v_list <- list(1, 2)

test_that("`check_z` can pass the check when needed", {
  expect_equal(check_z(z_2, v_2), invisible())
  expect_equal(check_z(z_high, v_2), invisible())
})

test_that("`check_z` can deal with illogical values", {
  expect_error(check_z(z_na, v_2))
  expect_error(check_z(z_nan, v_2))
  expect_error(check_z(z_null, v_2))
  expect_error(check_z(z_char, v_2))
  expect_error(check_z(z_toofew, v_2))
  expect_error(check_z(z_toomany, v_2))
  expect_error(check_z(z_vec, v_2))

  expect_error(check_z(z_2))
  expect_error(check_z(z_2, v_na))
  expect_error(check_z(z_2, v_nan))
  expect_error(check_z(z_2, v_null))
  expect_error(check_z(z_2, v_char))
  expect_error(check_z(z_2, v_toofew))
  expect_error(check_z(z_2, v_toomany))
  expect_error(check_z(z_2, v_list))
})
