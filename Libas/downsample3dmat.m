% resamples 3dim WAmatrixfunction [outWaMat] = downsample3dmat(inMat, sampnew, sampold);for freq = 1:size(inMat,3)outWaMat(:,:,freq) =resample(inMat(:,:,freq)',sampnew,sampold)';   end