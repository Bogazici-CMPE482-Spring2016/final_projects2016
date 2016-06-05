from __future__ import division

from solve_algorithms import solve_svd, solve_QR, solve_normal

import numpy as np

import matplotlib.pyplot as plt

def distance(x, y):
    n = len(x)

    x = np.array(x)
    y = np.array(y)
    d = np.sum(np.power(x-y,2))

    return np.sqrt(d)

def rey_quo(A, x):
    return np.dot(np.transpose(x), np.dot(A, x))/np.linalg.norm(x)

def poweriter(A, w):
    n = len(A[0])
    b1 = np.ones(n)/np.sqrt(n)
    b2 = np.ones(n)
    c = 1
    o = 0
    while o < 1000:
        b2 = solve_normal(A, b1/c)
        c = np.linalg.norm(b2)
        b1 = b2
        o +=1
        
    return b2
        
# k-nearest neighbor graph
def knng(X, k= 5, sig= 0.3, tau= 0):
    n = len(X[0])
    m = len(X[:])

    if n == 2:
        fig = plt.figure()
        plt.plot(X[:,0], X[:,1], ls= '', marker = 'o', ms=3.5, color= 'blue')
        plt.savefig('fig1.eps')
        
    dist = np.zeros((m,m))
    dist2 = np.zeros((m,m))
    for i in xrange(m):
        for j in xrange(m):
            if i == j:
                dist[i][j] = 1000000000
                dist2[i][j] = 0
            else:
                dist2[i][j] = distance(X[i], X[j])
                dist[i][j] = distance(X[i], X[j])

    edgelist = []
    for i in xrange(m):
        edge = []
        for j in xrange(k):
            edge.append(np.argmin(dist[i,:]))
            dist[i, edge[j]] = 1000000000
        edgelist.append(edge)

    if n == 2:
        for i in xrange(m):
            for j in xrange(k):
                plt.plot([X[i][0], X[edgelist[i][j]][0]],
                         [X[i][1], X[edgelist[i][j]][1]], color= 'blue')

        plt.savefig('fig2.eps')

    W = np.zeros((m,m))
    D = np.zeros((m,m)) # actually D^-1
    for i in xrange(m):
        for j in xrange(k):
            W[i][edgelist[i][j]] = np.exp(-0.5*(dist2[i][edgelist[i][j]]/sig)**2)
        D[i][i] = 1/np.sum(W[i])
            
    # Find eigenvector
    L = np.identity(m) - np.dot(W, D)
    e_vec = poweriter(L, 0)
    e_val = rey_quo(L, e_vec)


    Labels = []
    X_clus1 = []
    for i in xrange(m):
        if e_vec[i] < tau:
            Labels.append(1)
            X_clus1.append(X[i])
        else:
            Labels.append(2)

    X_clus1 = np.array(X_clus1)
    plt.plot(X_clus1[:,0], X_clus1[:,1], ls= '', marker = 's',
             ms=4.5, color= 'red')
    plt.savefig('fig3.eps')
    
    # Histogram
    hist, bin_edges = np.histogram(e_vec)
    fig2 = plt.figure()
    plt.bar(bin_edges[0:-1], hist, bin_edges[1]-bin_edges[0])
    plt.savefig('fig4.eps')

    return Labels, W 
    
if __name__ == '__main__':
    np.random.seed(1992)
    
    m = 100
    n = 2
    X = []
    for i in xrange(m):
        X.append(np.random.rand(n))

    X = np.array(X)
    knng(X, k=5)
