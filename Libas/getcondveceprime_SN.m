% getcondveceprime% searches condnumberes in e-prime *.txt filefunction [con4EEG, contentvec123, condvec] = getcondveceprime_SN(filepath);condvec = []; picvec = [];fid = fopen(filepath)a = 1	 while a > 0	a = fgets(fid); 	index1 = findstr(a, 'Procedure: '); 		    if ~isempty (index1);		proc = deblank(a(index1+11:length(a)));                                if strcmp(proc, 'tarproc') | strcmp(proc, 'tarDRproc') | strcmp(proc,'tarLRproc') | strcmp(proc,'tarDGproc'), condvec = [condvec 1];            elseif strcmp(proc, 'attstdproc1') | strcmp(proc,'std1DRproc') | strcmp(proc,'attstdLGproc'), condvec = [condvec 2];            elseif strcmp(proc, 'attstdproc2') | strcmp(proc, 'std2DRproc') | strcmp(proc,'attstdDRproc'), condvec = [condvec 3];               elseif strcmp(proc, 'nonattstdproc') | strcmp(proc, 'notarDRproc') |strcmp(proc,  'nonattstLRproc') | strcmp(proc, 'nonattstdDGproc'), condvec = [condvec 4];              end        end                index2 = findstr(a, 'tarpic');  index3 = findstr(a, 'targpic'); 		if ~isempty (index2) | ~isempty (index3)		picvec = [picvec str2num(a(length(a)-5:length(a)))];		end	 endfclose('all')picvec = picvec';condvec = condvec'; erotica = [4599:4695];adventure = 8021:8499; neutral_complex = [2520,2495,2305,2104,2191,2357,2351,2383,2102,2480,2372,2397,2514,2840,2487,2749,2595,2590,2272,2393,2235];neutral_simple = [2280,2214,2215,2230,2441,2493,2210,2200,2512,2499,2190,2516,2795,2025,2506,2635,2220,2221,2271];attack = [2683:2691  3500 3530  6211:6571 6838 9423:9425];mutilations = [3000:3266 3550 6021 6022]; for index = 1:size(picvec,1);     if ismember(picvec(index),erotica), contentvec123(index) = 10;    elseif ismember(picvec(index),adventure), contentvec123(index) = 20;    elseif ismember(picvec(index),neutral_simple), contentvec123(index) = 30;    elseif ismember(picvec(index),neutral_complex), contentvec123(index) = 40;    elseif ismember(picvec(index),attack), contentvec123(index) = 50;    elseif ismember(picvec(index),mutilations), contentvec123(index) = 60;    else contentvec123(index) = 99, pause    endendcontentvec123 = contentvec123'con4EEG = contentvec123 + condvec; eval(['save ' filepath '.con con4EEG -ascii'])