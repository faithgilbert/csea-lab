% sampelt down durch auslassen jeden zweiten wertesSampRateNew = input('new sampling Rate - must be half of old rate       ')[filemat] = getfilesindir('ElNino:temp:temp')for fileindex = 1 : size(filemat, 1);[inMat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec]=ReadAvgFile (filemat(fileindex, :));Npointsold = length(inMat)%downVec = [1:2:Npointsold];outMat=inMat(:,downVec);StdChanTimeMatout = StdChanTimeMat(:,downVec);StdChanTimeMatout = richtigmat; SaveAvgFile(FilePath,outMat, NTrialAvgVec,StdChanTimeMatout,SampRateNew,MedMedRawVec,MedMedAvgVec)end