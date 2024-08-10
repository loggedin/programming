import unittest
import numpy as np
from procrustes import Procrustes

class TestProcrustes(unittest.TestCase):
    # B
    # (a)
    def test_t_initial(self):
        '''Test that t == 1 when Procrustes class is instantiated'''
        X0 = np.array([[ 2,  0,  1], [-2,  0,  0]])
        proc = Procrustes(X_ref = X0)
        # Specify test
        self.assertEqual(proc.t, 1)

    # (b)
    def test_orthogonal_matrix(self):
        '''Test that orthogonal_matrix returns an orthogonal matrix'''
        X0 = np.array([[ 2,  0,  1], [-2,  0,  0]])
        proc = Procrustes(X_ref = X0)
        Y = np.array([[ 1,  0,  2], [0,  0,  -2]])
        # Compute R using orthogonal_matrix
        R = proc.orthogonal_matrix(Y)
        # Compute the matrix product of R and RT
        RT = R.transpose()
        RRT = np.matmul(R, RT)
        # Specify test, using absolute tolerance specified in question
        self.assertTrue(np.allclose(RRT, np.identity(RRT.shape[0]), atol = 1e-8))

    # (c)
    def test_different_Y_X_ref(self):
        '''Test that ValueError raised if Y has a different dimension to X_ref and passed to orthogonal_matrix'''
        X0 = np.array([[ 2,  0,  1], [-2,  0,  0]])
        proc = Procrustes(X_ref = X0)
        Y = np.array([[ 2,  0,  1, 3], [-2,  0,  0, 4]])
        # Specify test
        self.assertRaises(ValueError, proc.orthogonal_matrix, Y)

    # (d)
    def test_t_increases(self):
        '''Test that t increases by 1 whenever update_Y_bar is called'''
        X0 = np.array([[ 2,  0,  1], [-2,  0,  0]])
        proc = Procrustes(X_ref = X0)
        # Save the current value of t
        t_current = proc.t
        # Call update_Y_bar and save the new value of t
        Y = np.array([[ 1,  0,  2], [0,  0,  -2]])
        proc.update_Y_bar(Y)
        t_new = proc.t
        # Specify test
        self.assertEqual(t_new - t_current, 1)

    # (e)
    def test_dist_Y_bar(self):
        '''Test that dist_Y_bar returns a value >= 0'''
        X0 = np.array([[ 2,  0,  1], [-2,  0,  0]])
        proc = Procrustes(X_ref = X0)
        # Call update_Y_bar to produce a more realistic test case
        Y = np.array([[ 1,  0,  2], [0,  0,  -2]])
        proc.update_Y_bar(Y)
        # Specify test
        self.assertTrue(proc.dist_Y_bar() >= 0)

# (f)

# terminal:
# > python3 test_procrustes.py 
# .....
# ----------------------------------------------------------------------
# Ran 5 tests in 0.002s
# 
# OK

if __name__ == '__main__':
    unittest.main()
