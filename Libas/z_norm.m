function [normmat] = z_norm(a)% z-transfomr of matrix a% a = inmat: observations by variables% if size(a, 2) > 1 % if it is a matrix or row vector; 	    for SubInd = 1 : size(a, 1)	         normmat(SubInd,:) = (a(SubInd,:) - nanmean(a(SubInd,:))) ./ nanstd(a(SubInd,:));    end    elseif size(a, 2) == 1 % if it is a column vector            normmat = (a-nanmean(a))./nanstd(a); end