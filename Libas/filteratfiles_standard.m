% filters a list of at files with lowpass as indicated in input arg cutoff% filters between 1 and 40 hzfunction[filtmat]=filteratfiles_standard(filemat);cutoffHzlow = 40; cutoffHzhigh = 1; for index = 1:size(filemat,1);         atgPath = deblank(filemat(index,:));	    [AvgMat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,SampRate] = ReadAvgFile(atgPath);         cutoff_ratioLow = cutoffHzlow *2/SampRate;	[B, A] = butter(5, cutoff_ratioLow);     	AvgMat = AvgMat';         filtmat = filtfilt(B,A, AvgMat)';         % optional highpass       if ~isempty(cutoffHzhigh);                  cutoff_ratioHigh = cutoffHzhigh *2/SampRate;            [B, A] = butter(5, cutoff_ratioHigh, 'high');            filtmat = filtfilt(B,A, filtmat')';     end    figure(1), title(atgPath);     plot(mean(filtmat(55,:))); hold on, plot(AvgMat(:,55), 'r'), pause(1), hold off		[File,Path,FilePath]=SaveAvgFile([atgPath '.f'],filtmat,NTrialAvgVec,StdChanTimeMat, SampRate);    %eval(['save ' deblank(atgPath) '.pha phasemat -ascii'])end