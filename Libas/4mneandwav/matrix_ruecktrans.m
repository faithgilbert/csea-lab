%transformiert fisherZ-Werte in r zur�ck;function [matrix]=ruecktrans(matrixZ);%[m n]=size(matrixZ);% matrixZ = matrixZ.*2;% for i=1:1:m; %       for j=1:1:n;% %             cell=matrixZ(i,j);%             r=(exp(2*cell)-1)/(exp(2*cell)+1);%             matrix(i,j)=r;% %        end;% end;matrix = (exp(matrixZ + matrixZ)-1)./(exp(matrixZ + matrixZ)+1);