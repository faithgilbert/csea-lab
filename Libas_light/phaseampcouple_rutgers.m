% magno_waveletfunction [CFCwithin, CFCacross, CFCwithin_norm, CFCacross_norm, powermat, phasemat, faxis ] = phaseampcouple_rutgers(mat, SampRate, f0start, f0end, fdelta, f0power, f0phase, timeinterval, plotflag); if nargin < 5,     refelec = []; end% 1. read data and calculate stuff for the wavelet analysisdata = mat;  NPointsNew = size(data,2);     NTrials = size(data,3);       allfreqspossible = 0:1000./(NPointsNew.*1000/SampRate):SampRate/2;    % compute wavelets and their parameters   wavelet = gener_wav(NPointsNew, fdelta, f0start, f0end);   disp('size of waveletMatrix')  disp(size(wavelet))  disp (' frequency step for delta_f0 = 1 is ')  disp(SampRate/NPointsNew)    disp('size of waveletMatrix')  disp(size(wavelet))  disp (' frequency step for delta_f0 = 1 is ')  disp(SampRate/NPointsNew)  disp(' actual wavelet frequencies (Hz) selected with these settings: ')  disp(allfreqspossible(f0start:fdelta:f0end))  reducedfreqs = allfreqspossible(f0start:fdelta:f0end);  disp(' wavelet frequencies (Hz) used for CFC: ')  disp(reducedfreqs([f0phase, f0power]))  faxis = reducedfreqs;     % create 3d matrix objects for wavelet   % channels * time * frequencies       waveletMat3d = repmat(wavelet, [1 1 size(data,1)]);     waveletMat3d = permute(waveletMat3d, [3, 2, 1]);         % loop over trials        disp(['trial index of '])    disp(NTrials)        for trialindex = 1:NTrials;                  Data = data(:,:,trialindex);                fprintf('.')                 if trialindex/10 == round(trialindex/10), disp(trialindex), end            Data = bslcorr(Data, 1:100);                size(Data);        % window data with cosine square window        window = cosinwin(20, size(Data,2), size(Data,1));         Data = Data .* window;                 data_pad3d = repmat(Data, [1 1 size(wavelet,1)]);             % transform data  to the frequency        data_trans = fft(data_pad3d, NPointsNew, 2);        thetaMATLABretrans = [];         ProdMat= waveletMat3d .*(data_trans);        thetaMATLABretrans = ifft(ProdMat, NPointsNew, 2);                % standardize instantaneous phase        stdcomplexphasemat = thetaMATLABretrans ./ abs(thetaMATLABretrans);                    powermat_all = abs(thetaMATLABretrans).* 10;          phasemat_all= angle(stdcomplexphasemat);                  size(powermat_all);                              if trialindex == 1           powermat = powermat_all(:, timeinterval, f0power);           phasemat = phasemat_all(:, timeinterval, f0phase);                        else            powermat = [powermat powermat_all(:, timeinterval, f0power)];           phasemat = [phasemat phasemat_all(:, timeinterval, f0phase)];        end    end % loop over trials        disp('done with wavelets');         %CFCacross     for chan1 = 1:size(data,1)                 [bins, centers] = hist(phasemat(chan1,:), 20);                   for chan2 = 1:size(data,1)                     for x = 2:20                indexvec = find(phasemat(chan1, :) < centers(x) & phasemat(chan1, :) > centers(x-1));                 powerbin(x-1)=mean(powermat(chan2,indexvec));                           end                powerbin_norm = powerbin./sum(powerbin);                                if plotflag, bar(centers(1:19), powerbin_norm), axis([-3.2 3.2 0.03 0.06]),  title(['cross-chan CFC' num2str(chan1), num2str(chan2)]), pause, end                CFCacross(chan1,chan2) = (max(powerbin_norm) - min(powerbin_norm))./ max(powerbin_norm);         end                  fprintf('.')        end        CFCwithin = diag(CFCacross);           disp('done with cfc, start random shuffling');  % random distribution based on shuffled phase datafor draw = 1:1  for chan1 = 1:size(data,1)                 [bins, centers] = hist(phasemat(chan1,:), 20);                   for chan2 = 1:size(data,1)                     for x = 2:20                indexvec = find(phasemat(chan1, :) < centers(x) & phasemat(chan1, :) > centers(x-1));                 temprandindices = randperm(length(powermat(chan2,:)));                               powerbin(x-1)=mean(powermat(chan2,temprandindices(1:length(indexvec))));              end                powerbin_norm_rand = powerbin./sum(powerbin);                              if plotflag==1 && draw==1                bar(centers(1:19), powerbin_norm_rand), title('rand distribution CFC'), pause(1)                end                CFCacross_rand(chan1,chan2, draw) = (max(powerbin_norm_rand) - min(powerbin_norm_rand))./ max(powerbin_norm_rand);         end      end   fprintf('.')  endsize(CFCacross_rand)      b = reshape(CFCacross_rand, 1, size(CFCacross_rand, 1)*size(CFCacross_rand,2)*size(CFCacross_rand,3));      mean_rand = mean(b)      std_mean = std(b)            [dum,centrand] = hist(b, 100);      c_crit = centrand(95)            CFCwithin_norm = (CFCwithin - mean_rand)./std_mean;      CFCacross_norm = (CFCacross - mean_rand)./std_mean;               