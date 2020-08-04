% Compute correlation of rows of matrices from different files with first principle component of rows of matrix from first file in namelist% namelist contains the filenames with matrices, pathname the path where all these files are stored, elplist contains electrodes to be excluded% (e.g. virtual eye electrodes!)% OH 07.11.97function [data, correl, meancor, stdcor, pcr] = pca_variability(pathname, namelist, elplist);max_electrodes = 29;				% Number of electrodes in the files (number of columns), also includes virtual eye electrodes!nr_names = length(namelist(:,1));% Determine valid electrodes to be included in the following procedurenr_electrodes = 0;for i=1:max_electrodes,	pruef = 0;	for j=1:length(elplist),		if elplist(j)==i,			pruef = 1;			break;		end;	end;	if pruef==0,		nr_electrodes = nr_electrodes + 1;		arg(nr_electrodes) = i;	end;end;colours = char('r', 'b', 'g', 'm', 'c', 'y', 'b', 'w');if nr_names>length(colours),	disp('Not enough colours for all files! (cnv_pca)');end;disp('Reading in data, average referencing');for i=1:nr_names,	name = sprintf('%s\\%s', pathname, namelist(i,:));	disp(name);	matrix = read_matrix(50,max_electrodes,name);		% 50 is upper bound	[m(i) n(i)] = size(matrix); 	data(1:m(i),:, i) =  matrix(:,arg);	data(1:m(i),:, i) = avg_ref(data(1:m(i),:, i)')';end;disp('Compute principal components of data files');for i=1:nr_names,	[pcc pcr(:,i)] = princ_comp(data(1:m(i),:, i)); 		% pcc not neededend;disp('Computing correlations');for i=1:nr_names,	correl(1:m(i),i) = correl_mat(data(1:m(i),:, i), pcr(:,i)');end;disp('Computing mean correlations');for i=1:nr_names,	meancor(i) = mean(correl(1:m(i),i));	stdcor(i) = std(correl(1:m(i),i), 1);end;disp('Plotting');clf;for i=10:nr_names,	if i<length(colours),		c = colours(i);	else		c = 'b';	end;	plot(correl(1:m(i),i), c); hold on;end;for i=1:nr_names,	if i<length(colours),		c = sprintf('%so', colours(i));	else		c = 'bo';	end;	x = 1:nr_names;	plot(i, meancor(i),  c); hold on;	axis([0 nr_names+1 -1 1]);end;legend(namelist(:,1:3), 4);  hold on;for i=1:nr_names,	if i<length(colours),		c = sprintf('%so', colours(i));	else		c = 'bo';	end;	x = 1:nr_names;	errorbar(i, meancor(i),stdcor(i),  c); hold on;	axis([0 nr_names+1 -1 1]);end;title('Mittlere Korrelationen und  deren Standardabweichungen der CNVs mit den Hauptkomponenten der Gruppen');%disp('Printing to file');%print -deps MadMac:matlab:data:aphasie:pictures:correl_pcacnv.eps;