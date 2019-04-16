clc;
f=inline('x^3-x-1'); 
[x,k]=bisect2(f,1,1.5,0.005)
[x,k]=bisect1(f,1,1.5,0.005)