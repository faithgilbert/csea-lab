% trasformiert in fisher Z-Wertefunction [transmat]=ztrans(matrix);[m n]=size(matrix);for i=1:1:m;       for j=1:1:n;              cell=matrix(i,j);              if cell>=1; cell=.999999999;end;	%r=1 abfangen da div by zero!              z=log((1+cell)/(1-cell));              transmat(i,j)=z;      end;        end;transmat = transmat ./ 2;