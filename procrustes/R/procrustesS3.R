procrust <- function(x = 0, y = 0){
  structure(list(X_ref = x, Y_bar = y, t = 1), class="procrust")
}

# declare get_X_ref function
get_X_ref <- function(p) UseMethod("get_X_ref")

# implement get_X_ref function; returns X_ref
get_X_ref.procrust <- function(p){
  return(p$X_ref)
}

# declare get_Y_bar function
get_Y_bar <- function(p) UseMethod("get_Y_bar")

# implement get_Y_bar function; returns Y_bar
get_Y_bar.procrust <- function(p){
  return(p$Y_bar)
}

# declare get_t function
get_t <- function(p) UseMethod("get_t")

# implement get_t function; returns t
get_t.procrust <- function(p){
  return(p$t)
}

# A
# (a)

# declare orthogonal_matrix function
orthogonal_matrix <- function(p, Y) UseMethod("orthogonal_matrix")

# implement orthogonal_matrix function; returns R
orthogonal_matrix.procrust <- function(p, Y){
  # Check that Y has the same dimension as p$X_ref
  if (!identical(dim(p$X_ref), dim(Y))) {
    stop("Y has a different dimension to X_ref")
  }
  # Compute the matrix product of YT and p$X_ref
  YT <- t(Y)
  YT_X_ref <- YT %*% p$X_ref
  # Compute the singular value decomposition
  SVD <- svd(YT_X_ref)
  U <- SVD$u
  V <- SVD$v
  VT <- t(V)
  return(U %*% VT)
}

# (b)

# declare rotated_Y function
rotated_Y <- function(p, Y) UseMethod("rotated_Y")

# implement rotated_Y function; returns YR
rotated_Y.procrust <- function(p, Y){
  # Compute R using orthogonal_matrix
  R <- orthogonal_matrix(p, Y)
  # Return the matrix product of Y and R
  return(Y %*% R)
}

# (c)

# declare update_Y_bar function
update_Y_bar <- function(p, Y) UseMethod("update_Y_bar")

# implement update_Y_bar function; updates p$t and p$Y_bar using eq. 7
update_Y_bar.procrust <- function(p, Y){
  p$t <- p$t + 1
  p$Y_bar <- (1 - 1 / p$t) * p$Y_bar + 1 / p$t * rotated_Y(p, Y)
  return(p)
}

# (d)

# declare dist_Y_bar function
dist_Y_bar <- function(p) UseMethod("dist_Y_bar")

# implement dist_Y_bar function; returns dp
dist_Y_bar.procrust <- function(p){
  dp <- sum(abs(p$Y_bar - p$X_ref) ** 2) ** 0.5
  return(dp)
}

# (e)

# declare update_reference function
update_reference <- function(p, rho) UseMethod("update_reference")

# implement update_reference function; updates p$X_ref
update_reference.procrust <- function(p, rho){
  # Compute dp using dist_Y_bar
  dp <- dist_Y_bar(p)
  # Update p$X_ref to p$Y_bar  if dp > rho
  if(dp > rho){
    p$X_ref <- p$Y_bar
  }
  return(p)
}

# (f)

# Implementation of print method for procrust
print.procrust <- function(p){
  cat("Procrustes object\n")
  cat("Matrix dimensions:", dim(p$X_ref), "\n")
  cat("Number of observations:", p$t)
}
