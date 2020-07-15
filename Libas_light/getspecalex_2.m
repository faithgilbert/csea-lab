  % getSpecAlex_2% generates low and high alpha spectral estimate with psd% for each channel for vglalph exp for condition 2function [low_alph, high_alph, all_alph] = getSpecAlex_2(infilepath);[Data,Version,LHeader,ScaleBins,NChan,NPoints,NTrials,SampRate,AvgRefStatus,File,Path,FilePath,EegMegStatus,NChanExtra]=...	ReadAppData(infilepath);			for trial = 1 : NTrials; 		data = ReadAppData(infilepath, trial);				% unterfenster		for channel = 1 : 129			for subset = 1 : 438 : 1315				psd_temp = psd(data(channel,[0+subset:200+subset+512]),250, 512);				if subset == 1, 					low_alph_trial(channel) = psd_temp(5);					high_alph_trial(channel) = psd_temp(7);					all_alph_trial(channel) = mean(psd_temp(5:7));				else					low_alph_trial(channel) = low_alph_trial(channel) + psd_temp(5); 					high_alph_trial(channel) = high_alph_trial(channel) + psd_temp(7);					all_alph_trial(channel) = all_alph_trial(channel) + mean(psd_temp(5:7));				end % if						end % subset			low_alph_trial(channel) = low_alph_trial(channel) ./ 4 ;			high_alph_trial(channel) = high_alph_trial(channel) ./ 4;			all_alph_trial(channel) = all_alph_trial(channel)./ 4;					end % channel			if trial == 1			low_alph = low_alph_trial;			high_alph = high_alph_trial;			all_alph = all_alph_trial;		else			low_alph = low_alph + low_alph_trial;			high_alph = high_alph + high_alph_trial;			all_alph = all_alph + all_alph_trial;		end			end % trial		low_alph = low_alph ./ NTrials;	high_alph = high_alph ./ NTrials;	all_alph = all_alph ./ NTrials;	eval(['save ' infilepath '.low low_alph -ascii'])		eval(['save ' infilepath '.hig high_alph -ascii'])		eval(['save ' infilepath '.all all_alph -ascii'])					