function ref = avg_ref(matrix);mean_col = mean(matrix', 2);for i=1:length(matrix(1,:)),	ref(:,i) = matrix(:,i)-mean_col(i);end;