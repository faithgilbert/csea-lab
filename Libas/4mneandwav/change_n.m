%==================================================================%%	change_n3_nn.m%%	Markus Junghoefer	[1995]%%%	This will change a n x 3 matrix in one sqrtn x sqrtn matrices%	%	Function definition	function[X]=change_n3_nn(A)%=================================================================if nargin<1; return; end[m,n]=size(A);		if m==1 & n~=1; A=A';endSqrtN=sqrt(n);if SqrtN-floor(SqrtN)~=0; fprintf('No square matrix in change_n3_nn');return; endX=zeros(SqrtN);i=0;for j=1:SqrtN;	for k=1:SqrtN;		i=i+1;		X(j,k)=A(i);	endend		return;%=================================================================