function varargout = armorf(x,ntrls,npts,p)

%ARMORF   AR parameter estimation via LWR method by Morf modified.

%   X is a matrix whose every row is one variable's time series
%   ntrls is the number of realizations, npts is the length of every realization
%   If the time series are stationary long, just let ntrls=1, npts=length(x)
%
%   A = ARMORF(X,NR,NL,ORDER) returns the polynomial coefficients A corresponding to 
%   the AR model estimate of matrix X using Morf's method.
%   ORDER is the order of the AR model.
%
%   [A,E] = ARMORF(...) returns the final prediction error E (the variance
%   estimate of the white noise input to the AR model).
%
%   [A,E,K] = ARMORF(...) returns the vector K of reflection coefficients (parcor coefficients).
%
%   Ref: M. Morf, etal, Recursive Multichannel Maximum Entropy Spectral Estimation,
%              IEEE trans. GeoSci. Elec., 1978, Vol.GE-16, No.2, pp85-94.
%        S. Haykin, Nonlinear Methods of Spectral Analysis, 2nd Ed.
%              Springer-Verlag, 1983, Chapter 2
%
%   finished on Aug.9, 2002 by Yonghong Chen

% Initialization
[L,N]=size(x);
R0=zeros(L,L);
R0f=R0;
R0b=R0;
pf=R0;
pb=R0;
pfb=R0;
ap(:,:,1)=R0;
bp(:,:,1)=R0;
En=R0;

for i=1:ntrls
    En=En+x(:,(i-1)*npts+1:i*npts)*x(:,(i-1)*npts+1:i*npts)';
    ap(:,:,1)=ap(:,:,1)+x(:,(i-1)*npts+2:i*npts)*x(:,(i-1)*npts+2:i*npts)';        
    bp(:,:,1)=bp(:,:,1)+x(:,(i-1)*npts+1:i*npts-1)*x(:,(i-1)*npts+1:i*npts-1)';
end

ap(:,:,1) = inv((chol(ap(:,:,1)/ntrls*(npts-1)))');
bp(:,:,1) = inv((chol(bp(:,:,1)/ntrls*(npts-1)))');

for i=1:ntrls
    efp = ap(:,:,1)*x(:,(i-1)*npts+2:i*npts);
    ebp = bp(:,:,1)*x(:,(i-1)*npts+1:i*npts-1);
    pf = pf + efp*efp';
    pb = pb + ebp*ebp';
    pfb = pfb + efp*ebp';
end
En = chol(En/N)'; % Covariance of the noise

% Initial output variables
coeff = [];%  Coefficient matrices of the AR model
kr=[];  % reflection coefficients

for m=1:p
   % Calculate the next order reflection (parcor) coefficient
   ck = inv((chol(pf))')*pfb*inv(chol(pb));
   kr=[kr,ck];
   % Update the forward and backward prediction errors
   ef = eye(L)- ck*ck';
   eb = eye(L)- ck'*ck;
     
   % Update the prediction error
   En = En*chol(ef)';
   E = (ef+eb)./2;   
   
   % Update the coefficients of the forward and backward prediction errors
   ap(:,:,m+1) = zeros(L);
   bp(:,:,m+1) = zeros(L);
   pf = zeros(L);
   pb = zeros(L);
   pfb = zeros(L);

   for i=1:m+1       
       a(:,:,i) = inv((chol(ef))')*(ap(:,:,i)-ck*bp(:,:,m+2-i));
       b(:,:,i) = inv((chol(eb))')*(bp(:,:,i)-ck'*ap(:,:,m+2-i));
   end
   for k=1:ntrls
       efp = zeros(L,npts-m-1);
       ebp = zeros(L,npts-m-1);
       for i=1:m+1
           k1=m+2-i+(k-1)*npts+1;
           k2=npts-i+1+(k-1)*npts;
           efp = efp+a(:,:,i)*x(:,k1:k2);
           ebp = ebp+b(:,:,m+2-i)*x(:,k1-1:k2-1);
       end
       pf = pf + efp*efp';
       pb = pb + ebp*ebp';
       pfb = pfb + efp*ebp';
   end
   ap = a;
   bp = b;
end
for j=1:p
    coeff = [coeff,inv(a(:,:,1))*a(:,:,j+1)];
end

varargout{1} = coeff;
if nargout >= 2
    varargout{2} = En*En';
end
if nargout >= 3
    varargout{3} = kr;
end    

clear L;
clear N;
clear R0;
clear R0f;
clear R0b;
clear pf;
clear pb;
clear pfb;
clear ap;
clear bp;
clear En;
clear i
clear efp;
clear ebp;
clear coeff;
clear kr;
clear m;
clear ck;
clear ef;
clear eb;
clear En;
clear E;
clear a;
clear b;
clear k;
clear k1;
clear k2;
clear j;



