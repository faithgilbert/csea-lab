%==================================================================%==================================================================%%	FilterBatch.m%%	Markus Junghoefer	[1999]%%%	Function definition%	%%%%%=================================================================%==================================================================global hPlot2dMenuFighPlot2dMenuFig=[];%dirname = input('insert path to files ')%[filemat, namelist, dirname] = getfilesindir(dirname);filemat = input('insert filemat or filename   ')if size(filemat, 1)==0; return; end%===============FilterFile====================================SampRate=input('insert sampling rate of ascii files   ');ChLowPassFilt=input('insert 1 if you want to filter lowpass, else 0   ');ChHighPassFilt=input('insert 1 if you want to filter highpass, else 0   ');HighDefFreqsMat=[SampRate 2 0];HighDefRipMat=[3 25];LowDefFreqsMat=[SampRate 20 25]; LowDefRipMat=[3 45];[ChLowPassFilt,LowB,LowA,ChHighPassFilt,HighB,HighA,LowFreqsMat,HighFreqsMat] = ...GetHighLowFiltCoeff(SampRate,HighDefFreqsMat,HighDefRipMat,LowDefFreqsMat,LowDefRipMat,...ChLowPassFilt,ChHighPassFilt);if ChLowPassFilt | ChHighPassFilt	for FileInd=1:size(filemat, 1)		AvgMat = load(filemat(FileInd, :));		[NChan,NPoints]=size(AvgMat);		if SampRate==SampRate;			if ChLowPassFilt				for i=1:NChan					AvgMat(i,:)=(filtfilt(LowB,LowA,AvgMat(i,:)'))';				end			end			if ChHighPassFilt				for i=1:NChan					AvgMat(i,:)=(filtfilt(HighB,HighA,AvgMat(i,:)'))';				end			end		end		SaveAvgFile([filemat(FileInd,:) '.atg.ar.f'],AvgMat,[],[],SampRate,[],[]);	endend