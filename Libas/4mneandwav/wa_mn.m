% compute wavelet for one epoch, all electrodes% hints: % bslmat = bslcorrwamat(AvgWaPower, [30:50]);% contourf(squeeze(AvgWaPower(12, :, :)))%function [AvgWaPower, PhasLockfac] = wa_avr(mnmatrix, NPointsold, nr_chnls, sample_int); % parameters for freq resolution  SampRate = 1000 / sample_int  delta_f0 = 2  f0_start = 8  f0_end = 90 % Npoints runden auf naechste 2erpotenz  matsize = 2;  potsize = 2;  while matsize < NPointsold;    potsize = potsize + 1;    matsize = 2^potsize;  end  NPointsNew = matsize;  disp('NPointsNew');  %disp(NPointsNew);    wavelet = gener_wav(NPointsNew, delta_f0, f0_start, f0_end);   disp('waveletsize');  %disp(size(wavelet)); % end parameters / wavelet   for e  = 1 :  nr_chnls;       fprintf('wavelet analysis of channel %g \n', e)	                    data_pad = [mnmatrix(e,:)'; zeros(NPointsNew-NPointsold,1)];       %disp(data_pad);              [WAPower, WARayleigh]=wa_new(data_pad, wavelet, NPointsNew, delta_f0, f0_start, f0_end, NPointsold);       AvgWaPower(e,:,:) = WAPower;       PhasLockfac(e,:,:) = WARayleigh; end; % electrodes e   