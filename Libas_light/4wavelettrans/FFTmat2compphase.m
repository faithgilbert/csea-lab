%FFTmat2compphase% reads complex FFT mat and divides each value by% the magnitude, to get complex phasefunction [compphasemat] = FFTmat2compphase(inmat);compphasemat = zeros(size(inmat));for index1 = 1 : size(inmat, 1)	for index2 = 1:size(inmat, 2)				compphasemat(index1, index2) = inmat(index1, index2) ./ abs(inmat(index1, index2));	endend