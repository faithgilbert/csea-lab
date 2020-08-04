% Divide data set into mictrostates, i.e. find topographies that explain a certain amount% of variance in a corresponding time range% begin: start looking for the first time segment from "begin" on% threshold: variance (in %) that shall be at most remain unexplained by corresponding topographies% norm_flag: if 'norm', then normalize columns of data sets before computing microstates% SNR_parameters: Signal to noise ratio is also used as a criterion to find microstates%	If SNR<SNR_parameters(1) do not use timepoint for microstate, SNR is the ratio of mean RMS of microstate%	and mean RMS of baseline, SNR_parameters(2): Baseline begin, SNR_parameters(3): Baseline end% Output: Stateselem([1 2],1:number of mictrostates) : Time ranges of mictrostates%			 statestopo(:,1:number of microstates): Corresponding topographies (first principal component)% Fehler noch zu beheben: In Z. 31 SNR_parameters in Matrixindizes umrechnen!!!function [stateselem, statestopo, states_SNR, states_rms] = micro_states(matrix, begin, threshold, norm_flag, SNR_parameters);if nargin==0,   disp(' [stateselem, statestopo, states_SNR, states_rms] = micro_states(matrix, begin, threshold, norm_flag, SNR_parameters); ');   return;end;if isempty(begin),   begin = 1;end;[m n] = size(matrix);rms = norm_col(matrix);		% compute root mean squares for matrix columnsif ~isempty(SNR_parameters),   disp('Compute SNRs');   mean_base_rms = mean(rms(SNR_parameters(2):SNR_parameters(3)));		% compute mean RMS for baseline interval   SNR = rms/mean_base_rms;else,   SNR(1:n) = inf;end;if strcmp(norm_flag, 'norm'),   disp('Normalizing matrix columns');   matrix = normalize_cols(matrix);else,   disp('Not normalizing matrix columns');end;first = begin;counter = 1;			% Count microstatesdisp('Loop for microstates');for i=begin+1:n,   ev = svd(matrix(:,first:i));		% Eigenvalues for actual time range   var = 100.0*(1.0-ev(1)^2/sum(ev.^2));		% Corresponding residual variance for first component   if var>threshold,							% If enough variance is explained by first component...      stateselem(1,counter) = first;	% Keep time range for actual microstate      stateselem(2,counter) = i-1;      [u,s,v] = svd(matrix(:,first:i-1));      statestopo(:,counter) = u(:,1);		% Keep first components topography      states_SNR(counter) = mean(SNR(first:i-1));		% Mean signal to noise ration in microstate interval      states_rms(counter) = mean(rms(first:i-1));		% Mean root mean square in microstate interval      clear u; clear s; clear v;      first = i;      counter = counter + 1;   end;end;