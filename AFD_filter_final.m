function [f_recovery_final,F,coef,a] =AFD_filter( f,SNR,n,tol)
%
% [f_recovery_final,F,coef,a] =AFD_filter( f,SNR,n,tol)
%
% This function is the filter based on the adaptive Fourier decomposition.
% The detail process of this method can be found in the paper: 
%
% Ze Wang, Feng Wan, Chi Man Wong and Liming Zhang, "Adaptive Fourier
% decomposition based ECG denoising" accepted by Computers in Biology and Medicine.
%
% Input : 'f' is real signal;
%         'n' is the maximal steps of the decomposition and the default n is 100;
%         'SNR' is the SNR of the noisy signal;
%         'tol' is the tolerance and the default tol is 1e-3;
%       
% Output: 'f_recovery_final' is the signal recovered by AFD;    
%         'F': mono-components
%         'coef': coefficiences of mono-components
%         'a': a_n
%
% Note:
%   The mean value or linear trend should be removed before using this
%   function. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(nargin<2)
    error('need f and SNR');
elseif(nargin==2)
    n=200;
    t=linspace(0,2*pi,length(f));
    tol=1e-3;
elseif(nargin==3)
    t=linspace(0,2*pi,length(f));
    tol=1e-3;
else
    t=linspace(0,2*pi,length(f));
end

f=hilbert(f);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[l,m]=size(f);
G=zeros(n,m);
a=zeros(n,1);
G(1,:)=f;
C=Unit_Disk;
[N,M1]=size(C);
Weight=weight(length(f),6);
f2=abs(intg(f,f,Weight));
Base=zeros(length(C),m);
coef=zeros(n,1);
S1=zeros(size(C));
err=10;
tem_B=1;
%%
%tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute e_a of the unit disk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:N
      Base(k,:)=e_a(C(k),exp(t.*1i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The process of AFD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    j=1;
    fn=0;
    coef(j)=intg(f,ones(size(t)),Weight);
    a(j)=0;
    tem_B=(sqrt(1-abs(a(j))^2)./(1-conj(a(j))*exp(t.*1i))).*tem_B;
    F(j,:)=coef(j).*tem_B;
    fn=fn+F(j,:);
    tem_B_store(j,:)=tem_B;
    %
    old_diff=inf;
    new_diff=abs((intg(real(f),real(f),Weight)/(sum(abs(coef).^2).*0.5+0.5*abs(coef(1)).^2)-...
        (1+1/(10^(SNR/10)))));
while err>=tol&&j<=n-1
    j=j+1;
    G(j,:)=((G(j-1,:)-coef(j-1).*e_a(a(j-1),exp(t.*1i))).*(1-conj(a(j-1)).*exp(t.*1i)))./(exp(t.*1i)-a(j-1));%Decompose the signal f;
    I=0;
    S1=conj(Base*(G(j,:)'.*Weight));%Using the maximal selection principle to find a;
    [M,I]=max(abs(S1));
    coef(j)=S1(I);a(j)=C(I);
    tem_B=(sqrt(1-abs(a(j))^2)./(1-conj(a(j))*exp(t.*1i))).*((exp(1i*t)-a(j-1))./(sqrt(1-abs(a(j-1))^2))).*tem_B;%Using the relationship between the m-th
    F(j,:)=coef(j).*tem_B;                                                                                          %and the (m-1)-th Blaschke product to compute the product;
    tem_B_store(j,:)=tem_B;
    fn=fn+F(j,:);
    %
    if new_diff>old_diff
        break
    else
        old_diff=new_diff;
        new_diff=abs((intg(real(f),real(f),Weight)/(sum(abs(coef).^2).*0.5)-...
        (1+1/(10^(SNR/10)))));
    end
end

if(err==tol || j==n-1)
     disp('tol or n is not big enough');
     f_recovery_final= real(fn);
else
     f_recovery_final= real(fn);
end

end