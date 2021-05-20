function [ret] = Unit_Disk(dist)
%Discrete the unit disk;
%input:dist is the step distance and the default is 0.02;
%Output is an array;
if nargin==0
    dist=0.02;
end
t=-1:dist:1;
real=t;image=t;
[m,n]=size(t);
for j=1:n
    for k=1:n
        ret1(j,k)=real(j)+image(k)*1i;
    end
end
ret1=reshape(ret1,n^2,1);
ret2=ret1.*(abs(ret1)<0.99);
ret2=sort(ret2);
for j=1:n^2
    k=0;
    if(abs(ret2(j))>0)
        k=j;
        break
    end
end
ret=[ret2(k:n^2);0];
end

