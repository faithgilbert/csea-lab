% sampelt up mittels resample.mSampRateNew = input('new sampling Rate - must be double of old rate       ')[inMat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec]=ReadAvgFile;Npointsold = length(inMat)sampNewMat = resample(inMat',2,1);outMat = sampNewMat(150: 661, :);outMat = outMat';SaveAvgFile(FilePath,outMat, NTrialAvgVec,StdChanTimeMat,SampRateNew,MedMedRawVec,MedMedAvgVec)