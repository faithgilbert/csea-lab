% Computes sum over columns from to to of matrix% If no from/to specified: Take all columns% OH 25.10.97function [vec] = sum_columns(matrix, from, to);[m n] = size(matrix);if nargin == 1	from = 1;	to = n;end;u = ones(to-from+1,1);vec = matrix(:,from:to)*u;clear u;