# source the functions
source("procrustesS3.R")
library("testthat")

# specifying tolerance
tol <- 1e-8

# B
# (a)

test_that("t attribute equals 1 when Procrustes class is instantiated", {
  X0 <- matrix(c(2, -2, 0, 0, 1, 0), nrow=2)
  proc <- procrust(x = X0, y = X0)
  # Specify test
  expect_equal(proc$t, 1)
})

# (b)

test_that("orthogonal_matrix returns an orthogonal matrix", {
  X0 <- matrix(c(2, -2, 0, 0, 1, 0), nrow=2)
  proc <- procrust(x = X0, y = X0)
  Y <- matrix(c(1, 0, 0, 0, 2, -2), nrow=2)
  # Compute R using orthogonal_matrix
  R <- orthogonal_matrix(proc, Y)
  # Calculate the matrix product of R and RT
  RT <- t(R)
  R_RT <- R %*% RT
  # Specify test, using tolerance specified in question
  expect_equal(R_RT, diag(nrow=nrow(R_RT)), tolerance = tol)
})

# (c)

test_that("error raised if Y has a different dimension to X_ref and passed to orthogonal_matrix", {
  X0 <- matrix(c(2, -2, 0, 0, 1, 0), nrow=2)
  proc <- procrust(x = X0, y = X0)
  Y <- matrix(c(2, -2, 0, 0, 1, 0, 3, 4), nrow=2)
  # Specify test
  expect_error(orthogonal_matrix(proc, Y))
})

# (d)

test_that("t increases by 1 whenever update_Y_bar is called", {
  X0 <- matrix(c(2, -2, 0, 0, 1, 0), nrow=2)
  proc <- procrust(x = X0, y = X0)
  # Save the current value of t
  t_current <- proc$t
  # Call update_Y_bar and save the new value of t
  Y <- matrix(c(1, 0, 0, 0, 2, -2), nrow=2)
  proc <- update_Y_bar(proc, Y)
  t_new <- proc$t
  # Specify test
  expect_equal(t_new - t_current, 1)
})

# (e)

test_that("dist_Y_bar returns a value >= 0", {
  X0 <- matrix(c(2, -2, 0, 0, 1, 0), nrow=2)
  proc <- procrust(x = X0, y = X0)
  # Call update_Y_bar to produce a more realistic test case
  Y <- matrix(c(1, 0, 0, 0, 2, -2), nrow=2)
  proc <- update_Y_bar(proc, Y)
  # Specify test
  expect_true(dist_Y_bar(proc) >= 0)
})

# (f)

# R console:
# > testthat::test_file("test_procrustesS3.R")
# [ FAIL 0 | WARN 0 | SKIP 0 | PASS 5 ]
