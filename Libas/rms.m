% rms.m% computes rms for avf or atg - format matrix, i.e. columns are % time pointsfunction [rmsvec] = rms(FilePath)inmat = readavgfile(FilePath);inmat = inmat(1:148,:); inmat(1,1)inmat = inmat([133:146 116:127 98:109 78:88 56:65 36:44 19:25 7:10 3], :);for timepoint = 1:size(inmat,2)		rmsvec(timepoint) = sqrt(sum (inmat(:, timepoint) .^ 2));	endeval(['save ' FilePath '.rms rmsvec -ascii'])