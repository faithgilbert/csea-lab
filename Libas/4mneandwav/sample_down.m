function newmatrix = sample_down(matrix, step, begin);if nargin==0,   disp(' newmatrix = sample_down(matrix, step); ');   return;end;if (nargin==2) | isempty(begin),   begin=1;end;[m n] = size(matrix);newmatrix = matrix(:,1:step:n);