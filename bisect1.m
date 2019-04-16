function [x,k]=bisect1(f,a,b,eps)
%此题先计算了达到精确值所要走的步数，再用for循环求解x
%kmax=1+floor((log(b-a)-log(eps))/log(2)) Kmax为达到输入精度要走的步数，书上公式
%f为待求函数，[a,b]为起始区间，eps为精度，有默认值
if nargin<4   
    eps=1e-5; %eps的默认值
end
fa=feval(f,a);
fb=feval(f,b);
if fa*fb>0
    disp('[a,b]不是有根区间!')
end
kmax=1+floor((log(b-a)-log(eps))/log(2)); 
for k=1:kmax
    x=(a+b)/2;
    fx=feval(f,x);
    if    fx*fa<0
          b=x;
          fb=fx;
    elseif  fx*fa>0
          a=x;
          fa=fx;
    else
        a=x;
        b=x;
        break;
    end
end
%若在for循环底部多加一步下面的判断，情况会不一样
%if(b-a)/2<eps
%        break;
%end
%x=(a+b)/2;
%这是因为先判断区间是否符合精度标准，再求该区间的x
