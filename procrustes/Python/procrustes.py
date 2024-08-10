import numpy as np

class Procrustes():

    def __init__(self,
                 X_ref : np.ndarray,
                 Y_bar : np.ndarray = None,
                 t : int = 1
                 ) -> None:
        """
        Parameters
        ----------
        X_ref : np.ndarray
            Reference shape with which to compare observations

        Y_bar : np.ndarray 
            Sample mean of orthogonally transformed observations 

        t : int 
            Number of observations seen so far

        Returns
        -------
        None
        """
        self.X_ref = X_ref
        self.Y_bar = Y_bar if Y_bar is not None else X_ref 
        self.t = t  

    # A
    # (f)

    # Implementation of print method for Procrustes
    def __str__(self):
        s = "Procrustes object\nMatrix dimensions: " + str(self.X_ref.shape) + "\nNumber of observations: " + str(self.t)
        return s

    # (a)
    def orthogonal_matrix(self, Y):
        '''Returns R'''
        # Check that Y has the same dimension as self.X_ref
        if Y.shape != self.X_ref.shape:
            raise ValueError("Y has a different dimension to X_ref")
        # Compute the matrix product of YT and self.X_ref
        YT = Y.transpose()
        YT_X_ref = np.matmul(YT, self.X_ref)
        # Compute the singular value decomposition
        U, S, VT = np.linalg.svd(YT_X_ref)
        return np.matmul(U, VT)

    # (b)
    def rotated_Y(self, Y):
        '''Returns YR'''
        # Compute R using self.orthogonal_matrix
        R = self.orthogonal_matrix(Y)
        # Return the matrix product of Y and R
        return np.matmul(Y, R)

    # (c)
    def update_Y_bar(self, Y):
        '''Updates self.t and self.Y_bar using eq. 7'''
        self.t = self.t + 1
        self.Y_bar = (1 - 1 / self.t) * self.Y_bar + 1 / self.t * self.rotated_Y(Y)

    # (d)
    def dist_Y_bar(self):
        '''Returns dp'''
        # Not sure if np.linalg.norm is allowed so implementing manually
        dp = np.sum(np.abs(self.Y_bar - self.X_ref) ** 2) ** 0.5
        return dp

    # (e)
    def update_reference(self, rho):
        '''Updates self.X_ref to self.Y_bar if dp > rho'''
        # Compute dp using self.dist_Y_bar
        dp = self.dist_Y_bar()
        # Update self.X_ref to self.Y_bar if dp > rho
        if dp > rho:
            self.X_ref = self.Y_bar
