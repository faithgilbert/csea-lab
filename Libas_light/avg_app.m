% avg_appfunction [avgmat] = avg_app(infilepath, epochrange);for epoch_index = 1:length(epochrange)		trialmat = readappdata(infilepath,epochrange(epoch_index));		if  epoch_index == 1; 				summat = trialmat;			else		summat = summat + trialmat;			endendavgmat = summat ./ length(epochrange); 