from __future__ import division

from solve_algorithms import solve_svd, solve_QR, solve_normal

import numpy as np

# I could not find how to add seasonal terms
# and tried to add x^1/2 like terms but it turns out
# predictions are quite bad.

def weirdfunc(x, coef):
    a = coef
    
    ret = 0
    for i in xrange(len(a)):
        ret += a[i]*x**((-1)**i*(len(a)-i-1)/2.0)

    return ret

def weirdfit(x, y, dy= None, method= 'svd'):
    k = len(x)

    W = np.zeros((k,k))
    J = np.zeros((k,3))
    for i in xrange(3):
        J[:,i] = np.power(x, (-1)**i*i/2.0)

    np.fill_diagonal(W, np.power(dy,-2))

    JT = np.transpose(J)
    if method == 'svd':
        P = solve_svd(np.dot(JT, np.dot(W,J)),
                      np.dot(JT, np.dot(W,y)))
    if method == 'QR':
        P = solve_QR(np.dot(JT, np.dot(W,J)),
                     np.dot(JT, np.dot(W,y)))
    if method == 'normal':
        P = solve_normal(np.dot(JT, np.dot(W,J)),
                         np.dot(JT, np.dot(W,y)))

        
    return np.flipud(P)


if __name__ == '__main__':

    import matplotlib.pyplot as plt

    fig = plt.figure()
    
    a = np.load('./data/data_full.npy')
    x = np.linspace(1,24,24)
    x_pre = np.linspace(25,30,6)
    plt.plot(x,a[0], marker = 'o')

    coeff = weirdfit(x, a[0], dy = np.ones(len(x)))
    yfitted = [weirdfunc(x0, coeff) for x0 in x_pre]
    plt.plot(x_pre, yfitted, color= 'k', marker= 's', ls= '') 

    plt.ylim(np.min(a[0])*0.9, np.max(a[0])*1.1)
    plt.xlim(0,31)
    plt.show()
