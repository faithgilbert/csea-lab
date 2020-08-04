function [ pow, SNR ] = steadvec2singtrial(datavec, plotflag, bslvec, ssvepvec, foi, sampnew, SampRate)
%this one takes a ssVEP vector and outputs the power, i.e. one number
% sampnew is the NEW NEW sample rate  - user needs to calculate such that
%  integer number of sample points fits in a cycle  foi = freq of interest
%  in Hz
% SampRate is the OLD OLD OLD sample rate

ssvepvec = floor(ssvepvec .* (sampnew./SampRate)); 
 
 % this to be done outside the loop to save time, needed for winshift proc
 sampcycle=1000/sampnew; %added code for the new samplerate
 tempvec = round((1000/foi)/sampcycle); % this makes sure that average win duration is exactly @@, which is the duration in sp of one cyle at @@ Hz = @@ ms, sampled at 250 Hz
 longvec = repmat(tempvec,1,100); % repeat this many times, at least for duration of entire epoch, subsegments are created later 
 winshiftvec_long = cumsum(longvec)+ ssvepvec(1); % use cumsum function to create growing vector of indices for start of the winshift
 tempindexvec = find(winshiftvec_long > ssvepvec(end)); 
 
 endindex = tempindexvec(1);  % this is the first index for which the winshiftvector exceeds the data segment 
 winshiftvec = winshiftvec_long(1:endindex-4);

 % need this stuff for the spectrum
 shiftcycle=round(tempvec*4);
  samp=1000/sampnew;
        freqres = 1000/(shiftcycle*samp); %added code to find the appropriate bin for the frequency of interest for each segment
        freqbins = 0:freqres:(sampnew/2); 
        min_diff_vec = freqbins-foi;  %revised part
        min_diff_vec = abs(min_diff_vec); %revised
        targetbin=find(min_diff_vec==min(min_diff_vec)); %revised 
        

 Data = datavec;   
 
    fftamp = []; 
     SNR = []; 
        
     fouriersum = []; 
     normmat = []; 
   
    %============================================================
	% resample data
	%===========================================================   
    
        Data=double(Data');
            
        resampled=resample(Data,sampnew,SampRate);           
            
        Data = resampled';  
    
	%============================================================
	% 2. Baseline correction
	%===========================================================
	
	disp ('subtracting baseline')
	
    datamat = bslcorr(Data, bslvec);

%===========================================================
	% 3. moving window procedure with 4 cycles  !!!
	% 
	%===========================================================
	disp('moving window procedure')
	
	winmatsum = zeros(size(datamat,1),shiftcycle); %4 cycles
	
	 if plotflag, h = figure; end
   
     for winshiftstep = 1:length(winshiftvec)
		
        winmatsum = (winmatsum + regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))); % time domain averaging for win file
              
        %for within trial phase locking
        fouriermat = fft(regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))');
        fouriercomp = fouriermat(targetbin,:)'; 
        
        if winshiftstep ==1
            fouriersum = fouriercomp./abs(fouriercomp);
            normmat = fouriercomp./abs(fouriercomp); 
        else
            fouriersum = fouriersum + fouriercomp./abs(fouriercomp);
             normmat = [normmat fouriercomp./abs(fouriercomp)];
        end
        
       if plotflag
           subplot(2,1,1), plot(1:sampcycle:shiftcycle*sampcycle, regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))'), title(['sliding window starting at ' num2str((winshiftvec(winshiftstep))*sampcycle)  ' ms ']), xlabel('time in milliseconds')
           subplot(2,1,2), plot(1:sampcycle:shiftcycle*sampcycle, winmatsum'), title(['sum of sliding windows; number of shifts:' num2str(winshiftstep) ]), ylabel('microvolts')
          %    subplot(3,1,3), hold on, circle([0,0],1,200,'-');
          %    plot([0;(imag(fouriercomp(120)./tenHZampfft(120)))], [0;(real(fouriercomp(120)./tenHZampfft(120)))]);title('phase angle of window') 
           pause(.4)
       end
        
  %    movmat(index) = getframe(h)
  
    end
    
    winmat = winmatsum./length(winshiftvec);

	%===========================================================
	% 5. determine amplitude and Phase using fft of the winmat (i.e. the
	% average
	%===========================================================

	% FFT of the average winmat
	% 
	
	NFFT = shiftcycle-1; % one cycle in sp of the desired frequency times 4 oscillations (-1)
	NumUniquePts = ceil((NFFT+1)/2); 
	fftMat = fft (winmat', (shiftcycle-1));  % transpose: channels as columns (fft columnwise)
	Mag = abs(fftMat);                                                   % Amplitude berechnen
	Mag = Mag*2;   
	
	Mag(1) = Mag(1)/2;                                                    % DC trat aber nicht doppelt auf
	if ~rem(NFFT,2)                                                       % Nyquist Frequenz (falls vorhanden) auch nicht doppelt
        Mag(length(Mag))=Mag(length(Mag))/2;
	end
	
	Mag=Mag/NFFT;                                                         % FFT so skalieren, dass sie keine Funktion von NFFT ist
    
    pow = [Mag((targetbin),:)'];
    
    SNR = [log10(Mag((targetbin),:)'./ mean(Mag(([targetbin-2 targetbin+2]),:))').*10];
    




