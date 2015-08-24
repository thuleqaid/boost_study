import random
import sys

def randomGua(mode='CT'):
    if mode == 'TN':
        x = [random.randint(1, 1000) for i in range(3)]
        outtxt = '%s:%s'%(mode,','.join([str(i) for i in x]))
    else:
        x = []
        for idx in range(6):
            item = random.randint(0, 7)
            if item in (1, 2, 4):
                x.append(1)
            elif item in (3, 5, 6):
                x.append(2)
            elif item == 0:
                x.append(0)
            else:
                x.append(3)
        if mode == 'CT':
            x=[3-i for i in x]
            outtxt = '%s:%s'%(mode,''.join([str(i) for i in x]))
        elif mode == 'GC':
            x1 = 0
            x2 = []
            for idx,item in enumerate(x):
                x1 = x1*2 + (item%2)
                if item == 0 or item == 3:
                    x2.append(idx+1)
            x = [8-(x1%8), 8-(x1/8)] + x2
            outtxt = '%s:%s'%(mode,''.join([str(i) for i in x]))
        else:
            outtxt = '%s:%s'%(mode,''.join([str(i) for i in x]))
    return outtxt

if __name__ == '__main__':
    print(randomGua(sys.argv[1]))
