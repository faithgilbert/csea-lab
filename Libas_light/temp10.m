% tmp10mat = [];for epoch = 1 : 50	mat(epoch, :) = rand(1, 2048);endwavelet = gener_Wav(2048, 1, 10, 10);ValorMat = []for epoch = 1: 50ValorMat(epoch, :)= wa_ca(mat(epoch, :)', wavelet, 2048, 2047, 200);  endvec1 = 	abs(sum(ValorMat(1:25, :) - ValorMat(26:50, :)))./ 25;