% For given leadfield and inverse solution, the residual variance (sum of squares of differences% divided by sum of squares of data) of the forward solution of the inverse solution and% the data (columns of "data") is computed and output for every column of "data"% OH 05.12.97% uses norm_col()function [resvar, forward] = res_var(lfdmat, inv, data);if nargin==0,   disp(' resvar = res_var(lfdmat, inv, data) ');   return;end;if length(lfdmat(:,1))~=length(data(:,1)),   disp('Numbers of channels of lfdmat and data do not match!!! (res_var) ');   return;end;if length(lfdmat(1,:))~=length(inv(:,1)),   disp('Dimensions of source space of lfdmat and inv do not match!!! (res_var) ');   return;end;forward = lfdmat*inv;diff = data-forward;diffnorm = norm_col(diff, 2);clear diff;datnorm = norm_col(data, 2);resvar = (diffnorm./datnorm)';