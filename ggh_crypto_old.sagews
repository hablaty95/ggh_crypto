
from math import *
import random
class GGH:
    def __init__(self, n, level = 2):                        
        self.level = level
        self.n = n
        self.sk = self.generateSK()            
        self.pk = self.generatePK(self.sk)     
    def __encrypt__(self, msg, fact=3):
        r = self.randomFactor(fact)
        enc = msg*self.pk + r
        return enc
    
    def __decrypt__(self, enc):    
        ms = self.babai(enc)
        msg = self.pk.solve_left(ms)
        return msg
    
    def generateSK(self):
        identityMatrix = matrix.identity(self.n)
        goodBasis = random_matrix(ZZ, self.n, self.n, x = -self.level, y = self.level+1)
        scale = round(sqrt(n)) * self.level
        goodBasis = goodBasis + identityMatrix * scale
        return goodBasis
    
    def generatePK(self, sk):
        pk = sk
        for _ in range(self.level):
            scalingMatrix = self.randomScalingMatrix()
            pk = scalingMatrix * pk
        return pk
    
    def randomScalingMatrix(self):
        L = matrix(ZZ, self.n, self.n)
        for i in range(self.n):
            for j in range(i, self.n):
                if random.random() > 0.5:
                   L[i,j] = 1
                else:
                   L[i,j] = -1
        R = matrix(ZZ, self.n, self.n)
        for i in range(self.n):
            for j in range(i, self.n):
                if random.random() > 0.5:
                   R[i,j] = 1
                else:
                   R[i,j] = -1
        mat = L*R
        return mat
    
    def randomFactor(self, fact=3):
        randomVec = vector(ZZ, self.n)
        for i in range(self.n):
            if random.random() > 0.5:
                randomVec[i] = fact
            else:
                 randomVec[i] = -fact   
        return randomVec
    """
    def babai(self,enc):
        hRR = RealField(100)
        v = MatrixSpace(hRR, self.n, self.n)(self.sk)
        v.solve_left(enc)
        t = vector([int(round(i))  for i in v.solve_left(enc)])
        v = t * self.sk
        return v
    
    def babai(self, e):
        hRR = RealField(100)
        VV = MatrixSpace(hRR, self.n, self.n)(self.sk)
        VV.solve_left(e)
        t = vector([int(round(i))  for i in VV.solve_left(e)])
        v = t * self.sk
        print(f"babai:{v}")
        return v
        """
    def babai(self, w):
        vt = self.sk.solve_left(w)
        v = vector(ZZ, [0]*len(self.sk[0]))
        for t, vi in zip(vt, self.sk):
            v += round(t) * vi
        print(f"babai{v}")
        return v
    def HadamardRatio(B):
        n = B.ncols()
        H = (abs(B.det()) / product(v.norm() for v in B))^(1/n)
        return H


n = 10
ggh = GGH(n)
msg = vector(ZZ, [i for i in range(n)])

print(f"original message:{msg}")
enc = ggh.__encrypt__(msg)
print(f"encoded message:{enc}")
dec = ggh.__decrypt__(enc)
print(f"decoded message:{dec}")
msg == dec
lk= ggh.pk
ll = ggh.HadamardRatio(lk)
print(f"hadamard{ll}")









