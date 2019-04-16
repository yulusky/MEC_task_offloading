clc;
fun=@(x) x^3-x-1;
[x,k]=bisect1(fun,1,1.5,0.005);