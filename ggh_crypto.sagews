
'''
    Implementation of Goldreich–Goldwasser–Halevi (GGH) lattice-based asymethric cryptosystem.

    GGH:
    The private key is a basis of a lattice with good properties (such as short nearly orthogonal vectors) and a       unimodular matrix

    The public key is another basis of the same lattice, but with bad properties.


    Encryption
    Given a message m, and error e, and a public key
    enc := message * pk + e

    Decryption
    Given enc ciphertext and a secret key, ski = inverse(sk)
    enc * ski = (message * pk + e) * ski

    The Babai rounding technique will be used to remove the term e*ski as long as it is small enough.


    soure:
    https://en.wikipedia.org/wiki/GGH_encryption_scheme


    **
'''




from math import *
import random

class GGH2dim:
    '''
        Constructor, generating the keys
    '''
    def __init__(self):
        self.generateSK()
        self.generatePK()
        
        
    '''
        The process of encrypting, takes a 2 dimensional vector (message) as argument
        Returns with a 2 dimensional vector (encoded message)
    '''
    def __encrypt__(self, msg):
        print("The message: ")
        plot(msg)
        
        r = 1
        #r = random.randrange(0,3);
                

        enc = msg*self.pk
        enc[0] = enc[0] - r
        enc[1] = enc[1] + r
        
        
        print("Encrypted data: ")
        plot(enc)
        
        return enc

    
    '''
        The process of decrypting, takes 2 dimensional vector (encoded message) as argument
        Returns with a 2 dimensional vector (decoded message)
    '''
    def __decrypt__(self, enc):
        
        ms = self.sk.inverse() * enc
        rd = vector([round(ms[0]), round(ms[1])])
        msg = rd * self.um.inverse()
        return msg
    
    
    '''
        Secret key and unimodular matrix generation
        
        Generates a random matrix with elements between -3 and 3,
        and scales its diagonal up with an upscaled identitymatrix, making it a good basis for a lattice (having its base vectors nearly orthogonal)
        
        Also generates U, a random unimodular matrix
    '''
    def generateSK(self):
        identityMatrix = matrix.identity(2)
        goodBasis = random_matrix(ZZ, 2, 2, x = -3, y = 3)
        scale = 7
        goodBasis = goodBasis + identityMatrix * scale
        
        self.um = self.randomUnimodMat()
        self.sk = goodBasis
        
        print("The secret key vector: ")
        plot(goodBasis[0], color='blue', gridlines='minor') + plot(goodBasis[1], color='red')
        
     
        
    '''
        Public key generation
        
        Calculates the public key
        public key := secret key * random unimodular matrix
    '''
    def generatePK(self):
        pk = self.sk * self.um
        self.pk = pk
        
        print("The public key vector: ")
        plot(pk[0], color='blue', gridlines='minor') + plot(pk[1], color='red')
        
        
    '''
        Random unimodular matrix generation
        
        Generates 2 marticies with elements -1 and 1 randomly
        And multiplicates them creating an unimod mat.
    '''
    def randomUnimodMat(self):
        L = matrix(RR, 2, 2)
        for i in range(2):
            for j in range(i, 2):
                if random.random() > 0.5:
                   L[i,j] = 1
                else:
                   L[i,j] = -1
        R = matrix(ZZ, 2, 2)
        for i in range(2):
            for j in range(i, 2):
                if random.random() > 0.5:
                   R[i,j] = 1
                else:
                   R[i,j] = -1
        mat = L*R
        return mat
    
    
ggh2d = GGH2dim()

print("The secret key vector: ")
plot(ggh2d.sk[0], color='blue', gridlines='minor') + plot(ggh2d.sk[1], color='red')

print("The public key vector: ")
plot(ggh2d.pk[0], color='blue', gridlines='minor') + plot(ggh2d.pk[1], color='red')


msg = vector([0,1])
plot(msg)

print(f"original message:{msg}")
enc = ggh2d.__encrypt__(msg)
print(f"encoded message:{enc}")
dec = ggh2d.__decrypt__(enc)
plot(dec)
print(f"decoded message:{dec}")
msg == dec




'''
from math import *
import random


    #GGH in more dimensions


class GGHn:
    def __init__(self, n):
        self.n = n
        self.generateSK()
        self.generatePK()
        
        
   
    def __encrypt__(self, msg):
        r = 1
        #r = random.randrange(0,3);
                
        enc = msg*self.pk
        for i in range (self.n):
            if random.random() > 0.5:
                enc[i] += r
            else:
                enc[i] += -r
        
        return enc

    
    
    def __decrypt__(self, enc):
        
        ms = self.sk.inverse() * enc
        
        for i in range (self.n):
            ms[i] = round(ms[i])
        
        msg = ms * self.um.inverse()
        return msg
    
    
    
    def generateSK(self):
        identityMatrix = matrix.identity(self.n)
        goodBasis = random_matrix(ZZ, self.n, self.n, x = -3, y = 3)
        #print(goodBasis)
        
        #scale = round(sqrt(self.n)) * 4
        scale = 100
        
        goodBasis = goodBasis + identityMatrix * scale
        #print(goodBasis)
        self.um = self.randomUnimodMat()
        self.sk = goodBasis
        
     
        
    
    def generatePK(self):
        pk = self.sk * self.um
        self.pk = pk
        #print(pk)
        
        
    
    def randomUnimodMat(self):
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

    
n = 5
ggh2 = GGHn(n)
msg = vector(ZZ, [i for i in range(n)])

print(f"original message:{msg}")
enc = ggh2.__encrypt__(msg)
print(f"encoded message:{enc}")
dec = ggh2.__decrypt__(enc)
print(f"decoded message:{dec}")
msg == dec





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


n = 10
ggh = GGH(n)
msg = vector(ZZ, [i for i in range(n)])

print(f"original message:{msg}")
enc = ggh.__encrypt__(msg)
print(f"encoded message:{enc}")
dec = ggh.__decrypt__(enc)
print(f"decoded message:{dec}")
msg == dec





'''









