%==================================================================%%	stead2phaselock%% ermittelt fuer jede angegebene vp datenmatrix und% mittlere steady-state amplitude% % 	% %%Caution:psdvec = max-min - irrefuehrender Vektorname%!!!!!!!!!!! enter pairs as twocolumn-matrix%	%	Function definition function [phaselock_time, pairsynchmat] = stead2phaselock_MNE(filemat, pairmat, plotflag, G, indices_257_655);    if nargin < 2, plotflag = [], endexp = 'emosteady'ticfor fileindex = 1 : size(filemat,1);    	FilePath = filemat(fileindex,:);   	%===========================================================	% 1. lese daten einer vp und bedingung ein, falls nicht angegeben	%===========================================================		% if nargin<1;	% %rawmat = Readavgfile; % alles einschl baseline einlesen - atg junhoeferfile	% rawmat = read_avr_MEG(FilePath)	% else rawmat = Readavgfile(FilePath);	% end			[rawmat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,...		SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec,EegMegStatus,NChanExtra]= ReadAvgFile(FilePath);	%===========================================================	%filtern	%===========================================================	%disp('filtering data')		%filtmat=zeros(size(rawmat));		%M=[0 1 1 0 0];	%F=[0 0.004 0.2 0.2 1];		%[B, A] = YULEWALK(9,F,M);			%for nchan = 1 : 129;	%   Y = FILTFILT(B, A, rawmat(nchan,:));	%  filtmat(nchan,:) = Y;	%end		%%%%%% !!!!!!!	filtmat = rawmat;			%============================================================	% 2. Baselinekorrektur	%===========================================================		disp ('subtracting baseline')		dimrawfile = size (rawmat);		datamat = zeros(size(rawmat));		if exp == 'emosteady', latms = 3000; end		%latms = input('insert onset latency/baseline length (ms!!)    ');		latsp = latms/4;			bslvec = mean(filtmat(:,[latsp/2:latsp])');			for chan = 1 : size(datamat,1);				datamat(chan, :) = filtmat(chan,:) - bslvec(chan);		end				%===========================================================	% 3. moving window procedure mit jeweils 5 zyklen (=500ms/125sp),	% beginnend bei stimulusonset fuer alle kanaele. 	% shiften um 100ms (25sp) = 1 Zyklus	%===========================================================	disp('moving window procedure with MNE for each step ')		winmatsum = zeros(size(rawmat,1),125);	    fouriersum = zeros(1, size(rawmat,1));        interdiffsum = zeros(size(pairmat,1), 1);         %%%!!!!!!! here things are happening in source space......#@$#@$# 	    if plotflag, figure, end    	index = 1; 	for winshift = 0 : 25 : 1375 ; % shift nach baseline 101-1600        		winmatsum = (winmatsum + regressionMAT(datamat(:,[latsp+winshift:latsp+winshift+124])));                NFFT = 125; 	    NumUniquePts = ceil((NFFT+1)/2); 	    fftMat = fft(regressionMAT(datamat(:,[latsp+winshift:latsp+winshift+124]))', 128);  % transpose: channels as columns (fft columnwise)                tenHZampfft = abs(fftMat(6,:));                fouriercomp = fftMat(6,:);                % !!!!! from here in source space -  ab hier alles im quellraum               real_part = real(fouriercomp);           imag_part = imag(fouriercomp);                  inv_real =  G(3:3:1965,:) * real_part';			% Radial component                   inv_imag =  G(3:3:1965,:) * imag_part';               inv_real = inv_real(indices_257_655);               inv_imag = inv_imag(indices_257_655);                      fouriercomp = complex(inv_real, inv_imag)';               fouriersum = fouriersum + fouriercomp./abs(fouriercomp);                                            % inter site phase-locking                                for pairindex = 1:size(pairmat,1)                               interdiffsum(pairindex) = interdiffsum(pairindex) + (diff(fouriersum(pairmat(pairindex,:)))./abs(diff(fouriersum(pairmat(pairindex,:))))) ;             end                                     if plotflag           subplot(3,1,2), plot(regressionMAT(datamat(:,[latsp+winshift:latsp+winshift+124]))'), title(['sliding window starting at ' num2str((latsp+winshift)*4)  ' ms '])           subplot(3,1,1), plot(winmatsum'), title(['sum of sliding windows; number of shifts:' num2str(index) ])           subplot(3,1,3), hold on, polar(angle(fouriercomp(120)./tenHZampfft(120)), 1, 'rs');            pause(0.1)       else fprintf('.')       end                index = index+1; 	end    disp('')	winmat = winmatsum./56;        phaselock_time_complex = fouriersum ./56;     phaselock_pairs_complex = interdiffsum ./(56);         phaselock_time = abs(phaselock_time_complex)';         phaselock_pairs = abs(phaselock_pairs_complex);     angle_pairs = angle(phaselock_pairs_complex);        pairsynchmat = [phaselock_pairs(1:257) angle_pairs(1:257) phaselock_pairs(258:514) angle_pairs(258:514)]; 		% plot(winmat(73,:))	% title([FilePath])	% pause(5)		%===========================================================	% 3. detrending und demeaning der 5 verbleibenden zyklen:	% berechne least squares regression fuer jeden kanal	%===========================================================	%disp('demeaning of result')          	%	  for chan = 1:129;			  	%	      winmat(chan,:) = winmat(chan,:) 	%	  end	       	%===========================================================	% 5. determine overall amplitude and Phase using fft again in souce	% space	%===========================================================	disp(' ')    disp ('determining 10 Hz Phase per channel for the average...')		   NFFT = 125; 	NumUniquePts = ceil((NFFT+1)/2); 	fftMat = fft (winmat', 128);  % transpose: channels as columns (fft columnwise)	Mag = abs(fftMat);                                                   % Amplitude berechnen	Mag = Mag*2;   		Mag(1) = Mag(1)/2;                                                    % DC trat aber nicht doppelt auf	if ~rem(NFFT,2),                                                    % Nyquist Frequenz (falls vorhanden) auch nicht doppelt        Mag(length(Mag))=Mag(length(Mag))/2;	end			%tenHZampfft = sqrt(PowerMat(6,:));		FourierCompVec = fftMat(6,:);	       % !!!!! from here in source space -  ab hier alles im quellraum               real_part = real(FourierCompVec);        imag_part = imag(FourierCompVec);               inv_real =  inv_recon(G, real_part', 3);       inv_imag =  inv_recon(G, imag_part', 3);              inv_real = inv_real(indices_257_655);        inv_imag = inv_imag(indices_257_655);               fouriercomp = complex(inv_real, inv_imag)'; 		% for fft with amplitude scaling:			tenHZampfft = abs(fouriercomp).*100; 		PhaseMat = atan(inv_real./inv_imag);    	Phasevec = PhaseMat(6,:);			%===========================================================	% 6. bestimmung der mittleren Amplitude mit diffferenz(max-min)	%===========================================================			tenHZampfft = tenHZampfft';	    nanindex = find(isnan(pairsynchmat));     pairsynchmat(nanindex) = 1;     	%SaveAvgFile([FilePath '.amp' ],tenHZampfft,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus)        	%SaveAvgFile([FilePath '.win' ],winmat,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus)        	SaveAvgFile([FilePath '.pha' ],Phasevec,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus);        SaveAvgFile([FilePath '.Tlock' ],phaselock_time,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus);         SaveAvgFile([FilePath '.sync' ],pairsynchmat,NTrialAvgVec,[],SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus);    enda = toc; disp([num2str(a/60) ' minutes for this subject'])