# Name: Michael Hudson
# CID: 02287994

source("procrustesS3.R")

###START DO NOT MODIFY##
SEED <- 255
n <- 10
p <- 2
T_observations <- 20
std <- 0.01 
set.seed(SEED)

X0 <- matrix(rnorm(n*p), nrow=n, ncol=p) 
data <- array(dim = c(T_observations, n, p)) 
for (i in seq(1, T_observations)) { 
  #create ground truth orthogonal transformation matrix 
  R_true <- qr.Q(qr(matrix(rnorm(p*p), nrow=p, ncol=p))) 
  X <- X0 %*% R_true 
  
  # add iid Gaussian noise 
  noise <- std * matrix(rnorm(n*p), nrow=n, ncol=p) 
  X <- X + noise
  data[i, , ] <- X
}
###END DO NOT MODIFY####

# C
# (a)

proc <- procrust(x = X0, y = X0)

# (b)

# Update Y_bar sequentially for each element in data
for (i in seq(1, T_observations)) {
  proc <- update_Y_bar(proc, data[i, , ])
}

# Check that t = 21 after all updates have been implemented
cat(proc$t)

# (c)

# Save the current value of proc$X_ref
X_ref_current <- proc$X_ref
# Call update_reference with rho = 0.1 and save the new value of proc$X_ref
proc <- update_reference(proc, 0.1)
X_ref_new1 <- proc$X_ref

# Confirm that X_ref has not changed
if (identical(X_ref_new1, X_ref_current)){
  cat("When rho = 0.1, X_ref has not changed")
}

# Call update_reference with rho = 0.001 and save the new value of proc$X_ref
proc <- update_reference(proc, 0.001)
X_ref_new2 <- proc$X_ref

# Confirm that X_ref has changed
if (!identical(X_ref_new2, X_ref_current)){
  cat("When rho = 0.001, X_ref has changed")
}
