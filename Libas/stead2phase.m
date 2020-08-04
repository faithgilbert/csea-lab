%==================================================================%%	stead2amplitude%% ermittelt fuer jede angegebene vp datenmatrix und% mittlere steady-state amplitude% sliding window procedure% ermittlung von amplitude in steady state daten	% matlab 4 erforderlich wegen yulewalk filterdesign%%Caution:psdvec = max-min - irrefuehrender Vektorname%%	%	Function definition function [FourierCompVec] = stead2phase(filemat, plotflag);    if nargin < 2, plotflag = [], endfor fileindex = 1 : size(filemat,1);    	FilePath = filemat(fileindex,:);   		[rawmat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,...		SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec,EegMegStatus,NChanExtra]= ReadAvgFile(FilePath);		filtmat = rawmat;			%============================================================	% 2. Baselinekorrektur	%===========================================================		disp ('subtracting baseline')		dimrawfile = size (rawmat);		datamat = zeros(size(rawmat));		if exp == 'emosteady', latms = 3000; end		%latms = input('insert onset latency/baseline length (ms!!)    ');		latsp = latms/4;			bslvec = mean(filtmat(:,[latsp/2:latsp])');			for chan = 1 : size(datamat,1);				datamat(chan, :) = filtmat(chan,:) - bslvec(chan);		end				%===========================================================	% 3. moving window procedure mit jeweils 5 zyklen (=500ms/125sp),	% beginnend bei stimulusonset fuer alle kanaele. 	% shiften um 100ms (25sp) = 1 Zyklus	%===========================================================	disp('moving window procedure')		winmatsum = zeros(size(rawmat,1),125);		if plotflag, h = figure, end    	index = 1; 	for winshift = 0 : 25 : 1375 ; % shift nach baseline 101-1600        		winmatsum = (winmatsum + regressionMAT(datamat(:,[latsp+winshift:latsp+winshift+124])));               if plotflag           subplot(2,1,2), plot(1:4:125*4, regressionMAT(datamat(:,[latsp+winshift:latsp+winshift+124]))'), title(['sliding window starting at ' num2str((latsp+winshift)*4-3000)  ' ms ']), xlabel('time in milliseconds')           subplot(2,1,1), plot(1:4:125*4, winmatsum'), title(['sum of sliding windows; number of shifts:' num2str(index) ]), ylabel('microvolts')              subplot(3,1,3), hold on, circle([0,0],1,200,'-'); plot([0;(imag(fouriercomp(120)./tenHZampfft(120)))], [0;(real(fouriercomp(120)./tenHZampfft(120)))]);title('phase angle of window')            pause(0.1)           pause(.4)       end               movmat(index) = getframe(h)        index = index+1; 	end	winmat = winmatsum./56;		% plot(winmat(73,:))	% title([FilePath])	% pause(5)		%===========================================================	% 3. detrending und demeaning der 5 verbleibenden zyklen:	% berechne least squares regression fuer jeden kanal	%===========================================================	%disp('demeaning of result')          	%	  for chan = 1:129;			  	%	      winmat(chan,:) = winmat(chan,:) 	%	  end	       	%===========================================================	% 5. determine amplitude and Phase using fft	%===========================================================	disp ('determining 10 Hz Phase per channel')				% for fft with amplitude scaling:		NFFT = 125; 	NumUniquePts = ceil((NFFT+1)/2); 	fftMat = fft (winmat', 128);  % transpose: channels as columns (fft columnwise)	Mag = abs(fftMat);                                                   % Amplitude berechnen	Mag = Mag*2;   		Mag(1) = Mag(1)/2;                                                    % DC trat aber nicht doppelt auf	if ~rem(NFFT,2),                                                    % Nyquist Frequenz (falls vorhanden) auch nicht doppelt        Mag(length(Mag))=Mag(length(Mag))/2;	end		Mag=Mag/NFFT;                                                         % FFT so skalieren, da? sie keine Funktion von NFFT ist		tenHZampfft = Mag(6,:);		PowerMat = real(fftMat.*conj(fftMat)/125);		%tenHZampfft = sqrt(PowerMat(6,:));		PhaseMat = atan(real(fftMat)./imag(fftMat));	Phasevec = PhaseMat(6,:);	FourierCompVec = fftMat(6,:);			%===========================================================	% 6. bestimmung der mittleren Amplitude mit diffferenz(max-min)	%===========================================================		Phasevec = Phasevec';	tenHZampfft = tenHZampfft';		SaveAvgFile([FilePath '.amp' ],tenHZampfft,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus)        	SaveAvgFile([FilePath '.win' ],winmat,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus)        	SaveAvgFile([FilePath '.pha' ],Phasevec,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus)end