function [residual, snr_inv, snr_data, data, invsol_raw, invsol_abs] = gamma_test_regpar(name_in, regpar_vec, base_interval, signal_interval, namestem);if nargin==0,   disp(' [residual, snr_inv, snr_data, data, invsol_raw, invsol_abs] = gamma_test_regpar(name_in, regpar_vec, base_interval, signal_interval, namestem); ');   return;end;shell_from_elem = 1;		% Elements of shell to be considered (e.g. shell 2)shell_to_elem = 129;latencies = -100:2:922;[data] = readappdata(name_in);data = avg_ref(data);[dummy signal_from_elem] = min(abs(latencies-signal_interval(1)));[dummy signal_to_elem] = min(abs(latencies-signal_interval(2)));[dummy base_from_elem] = min(abs(latencies-base_interval(1)));[dummy base_to_elem] = min(abs(latencies-base_interval(2)));%lfdmat = read_matrix(1965, 129, 'e:\andreas\lfd129neu.dat')';snr_data = mean(rms(data(:,signal_from_elem:signal_to_elem)))/mean(rms(data(:,base_from_elem:base_to_elem)));	% Signal to noise ratio of datafor i=1:length(regpar_vec),   disp(i);      %G = pinv_tikh(lfdmat, regpar_vec(i)); 	csddata = app2csd(name_in, regpar_vec(i));	size(csddata)% 	invsol_raw = inv_recon(G, data, 1);%      	invsol_abs = inv_recon(G, data, 3);         %    residual(i) = mean(res_var(lfdmat, invsol_raw(:,signal_from_elem:signal_to_elem), data(:,signal_from_elem:signal_to_elem)));		% Residual Variance 		snr_inv(i) = mean(rms(csddata(:,signal_from_elem:signal_to_elem)))/mean(rms(csddata(:,base_from_elem:base_to_elem)));	% Signal to noise ratio of inverse solution      if ~isempty(namestem),	name_out = ['ubies:tmp:' namestem num2str(i)];      	write_avr(csddata(shell_from_elem:shell_to_elem,:), name_out, latencies(1), latencies(2)-latencies(1));   end;   end;