% getspec_avrfunction [avgspec, F] = getspec_avr(filemat); for index = 1 : size(filemat, 1)		a = read_avr(filemat(index,:));		[spec, F] = psd(a(41,800:3250),2048,400,[]);			if index == 1; 		sumspec = spec; 	else		sumspec = sumspec + spec; 	endendavgspec = sumspec ./ size(filemat,1); 