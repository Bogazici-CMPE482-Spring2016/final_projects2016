from __future__ import division

import numpy as np

from numpy.linalg import svd, qr, cholesky

# Solves Ax = b with svd.
def solve_svd(A, b):
    assert len(A[0]) == len(b)
    
    U, S, V = svd(A)
    UTb = np.dot(np.transpose(U), b)
    w = np.divide(UTb, S)

    return np.dot(np.transpose(V), w)

def solve_QR(A, b):
    n = len(b)
    Q, R = qr(A)
    
    QTb = np.dot(np.transpose(Q), b)

    x = np.zeros(n)
    for i in xrange(n-1, -1, -1):
        x[i] = (QTb[i] - np.dot(R[i,i+1:n], x[i+1:n]))/R[i,i]

    return x

def solve_normal(A, b):
    n = len(b)
    L = cholesky(np.dot(np.transpose(A),A))
    LT = np.transpose(L)

    ATb = np.dot(np.transpose(A), b)
        
    w = np.zeros(n)
    for i in xrange(0, n):
        w[i] = (ATb[i] - np.dot(L[i,0:i], w[0:i]))/L[i,i]
        
    x = np.zeros(n)
    for i in xrange(n-1, -1, -1):
        x[i] = (w[i] - np.dot(LT[i,i+1:n], x[i+1:n]))/LT[i,i]

    return x
