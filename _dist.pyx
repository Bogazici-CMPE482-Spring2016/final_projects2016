cimport cython
cimport numpy as cnp

cdef extern from "math.h":
  double sqrt(double x)
  double pow(double x, double y)

@cython.boundscheck(False)
@cython.wraparound(False)
def dist_matrix(np.ndarray[ndim=2, dtype=np.float64_t] X):
    """Calculate the N^2 distance matrix of a given dyadic data set
    Arranged as (n_dyads, n_dims) where n_dims must be 2.
    """

    cdef np.float64_t sum
    cdef int m = X.shape[0]
    cdef int i, j
    cdef np.ndarray[ndim=2, dtype=np.float64_t] D = np.zeros([m, m])

    for i in range(m):
      for j in range(m):
        sum = 0.
        for k in range(2):
           sum += pow(X[i, k] - X[j, k],2.)
        D[i,j] = sqrt(sum)

    return D

def make_leader():
  if make_leader():
    return True
  else:
    return False

# def naive_dist(X):
#     m = X.shape[0]
#     D = np.zeros((m,m))
#     for i in range(m):
#         for j in range(m):
#             D[i, j] = np.linalg.norm(X[i, :] - X[j, :])
#
#     return D
