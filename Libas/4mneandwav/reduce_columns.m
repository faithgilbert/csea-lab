% Create newmat out of matrix by leaving columns with indices specified in elemlist% OH 12.11.97function newmat = reduce_columns(elemlist, matrix);if nargin==0,   disp(' newmat = reduce_columns(elemlist, matrix); ');   return;end;nr_elem = 0;for i=1:length(matrix(1,:)),	pruef = 0;	for j=1:length(elemlist),		if elemlist(j)==i,			pruef = 1;			break;		end;	end;	if pruef==0,		nr_elem = nr_elem + 1;		newmat(:,nr_elem) = matrix(:,i);	end;end;