import numpy as np

# Returns numpy array. d is delimiter.
def readline(line, d = ' '):
    ret = []
    r = ''
    for l in line:
        if l == '\n':
            ret.append(float(r))
            break
        
        if l != d:
            r += l
        else:
            ret.append(float(r))
            r = ''
    return ret

def convert(fname):
    f = open(fname + '.txt', 'r')

    ret = []
    for line in f:
        ret.append(readline(line))

    np.save(fname, ret)

        
if __name__ == '__main__':
    convert('data_full')
    convert('data_miss')
