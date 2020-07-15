function [powermat, phasemat, CFCacross, fullspecmat ] = phaseampcoupling3d_between2files(matfilemat1, matfilemat2, f0start, f0end, fdelta, f0power, f0phase, timeinterval, plotflag);  SampRate = 500;for fileindex = 1:size(matfilemat1,1)          atemp1 = load(deblank(matfilemat1(fileindex,:)));      atemp2 = load(deblank(matfilemat2(fileindex,:)));          [a1,a2,a3] =  size(atemp1.outmat);  [b1,b2,b3] = size(atemp2.outmat);         data = cat(1, atemp1.outmat(:, :, 1:min(a3,b3)), atemp2.outmat(:, :, 1:min(a3,b3)));  % 1. read data to get info  NPointsNew = size(data,2);     NTrials = size(data,3);     allfreqspossible = 0:1000./(NPointsNew.*1000/SampRate):SampRate/2;    % compute wavelets and their parameters   wavelet = gener_wav(NPointsNew, fdelta, f0start, f0end);   disp('size of waveletMatrix')  disp(size(wavelet))  disp (' frequency step for delta_f0 = 1 is ')  disp(SampRate/NPointsNew)  disp(' actual wavelet frequencies (Hz) selected with these settings: ')  disp(allfreqspossible(f0start:fdelta:f0end))  reducedfreqs = allfreqspossible(f0start:fdelta:f0end);  disp(' wavelet frequencies (Hz) used for CFC: ')  disp(reducedfreqs([f0phase, f0power]))        % create 3d matrix objects for wavelet   % channels * time * frequencies       waveletMat3d = repmat(wavelet, [1 1 size(data,1)]);     waveletMat3d = permute(waveletMat3d, [3, 2, 1]);         % loop over trials        disp(['trial index of '])    disp(NTrials)        warning('off')        CFC = zeros(size(data,1),1);        for trialindex = 1:NTrials;                  Data = data(:,:,trialindex);                fprintf('.')                 if trialindex/10 == round(trialindex/10), disp(trialindex), end            Data = bslcorr(Data, 1:100);                size(Data);        % window data with cosine square window        window = cosinwin(20, size(Data,2), size(Data,1));         Data = Data .* window;                 data_pad3d = repmat(Data, [1 1 size(wavelet,1)]);             % transform data  to the frequency        data_trans = fft(data_pad3d, NPointsNew, 2);        thetaMATLABretrans = [];         ProdMat= waveletMat3d .*(data_trans);        thetaMATLABretrans = ifft(ProdMat, NPointsNew, 2);                % standardize instantaneous phase        stdcomplexphasemat = thetaMATLABretrans ./ abs(thetaMATLABretrans);                    powermat_all = abs(thetaMATLABretrans).* 10;          phasemat_all= angle(stdcomplexphasemat);                              if trialindex == 1           powermat = powermat_all(:, timeinterval, f0power);           phasemat = phasemat_all(:, timeinterval, f0phase);           fullspecmat = powermat_all;                         else            powermat = [powermat powermat_all(:, timeinterval, f0power)];           phasemat = [phasemat phasemat_all(:, timeinterval, f0phase)];           fullspecmat = fullspecmat+powermat_all;         end    end % loop over trials        fullspecmat = fullspecmat./NTrials;    spec = (squeeze(mean(fullspecmat, 2))')';         disp('done with wavelets');         %CFCacross     for chan1 = 1:size(data,1)                 [bins, centers] = hist(phasemat(chan1,:), 20);                   for chan2 = 1:size(data,1)                     for x = 2:20                indexvec = find(phasemat(chan1, :) < centers(x) & phasemat(chan1, :) > centers(x-1));                 powerbin(x-1)=mean(powermat(chan2,indexvec));                           end                powerbin_norm = powerbin./sum(powerbin);                                if plotflag, bar(centers(1:19), powerbin_norm), axis([-3.2 3.2 0.03 0.06]),  title(['cross-chan CFC' num2str(chan1), num2str(chan2)]), pause, end                CFCacross(chan1,chan2) = (max(powerbin_norm) - min(powerbin_norm))./ max(powerbin_norm);         end                  fprintf('.')        end        CFCwithin = diag(CFCacross);           disp('done with cfc, start random shuffling');  % random distribution based on shuffled phase data              cfcstring = [num2str(reducedfreqs(f0phase)) '_' num2str(reducedfreqs(f0power))];      %%%% !!!   % save output CFC as .atg file in scads format      outfilename = [deblank(matfilemat1(fileindex,:)) '.' cfcstring]     %eval(['save ' outfilename '.mat CFC'])      SaveAvgFile([outfilename '.cfc.betw2.at'],CFCacross,[],[], 1);   %SaveAvgFile([outfilename '.pow.at'],spec,[],[], 1);        warning('on')     end % loop over files       