% Computes a multiplication of the inverse with the data matrix and uses% single trials as the input.% Requires a valid leadfield matrix (lfdmat1) % Regpar = regularization parameter. To determine optimal regularization% parameter, use the regularisation_curve function. % pathname = present working directory that stores the files to be% analyzed.% namelist = file identification for the file and shell number to be analyzed% pathout = desired directory for the file to be written.% elplist = leave as [] % locations = sensor locations in Cartesian coordinates% from: beginning of analysis in sample points% to: end of analysis in sample points% out_flag: absolute ('abs') or radial ('rad') to preserve phase information % bslvec: length of baseline vector in sample pointsfunction [diploc, lfdmat, data, G, invsol] = invmap_reduce_app(lfdmat1, diploc, regpar, pathname, namelist, pathout, elplist, locations, from, to, out_flag, bslvec);if nargin==0,   disp(' [diploc, lfdmat, data, G, invsol] = invmap_reduce(lfdmat1, regpar, pathname, namelist, pathout, elplist, locations, from, to, out_flag); ');   return;end;isfrom = 1;if isempty(from),   isfrom=0;end;if ~isempty(namelist),	nr_names = length(namelist(:,1));	name = ([ pathname '/' namelist(1,:)]);        	disp(name);   disp('Reading data, average referencing');	%[matrix, latencies] = read_avr_bsl(name, [bslvec]);    [matrix,Version,LHeader,ScaleBins,NChan,NPoints,NTrials,SampRate,AvgRefStatus,File,Path,FilePath,EegMegStatus,NChanExtra,AppFileFormatVal]=...	ReadAppData(name);         [matrix] = bslcorr(matrix, bslvec);else   nr_names = 1;    matrix = ReadAppData(name); end;[m(1) n(1)] = size(matrix);disp(' Determine valid electrodes to be included in the following procedure');nr_electrodes = 0;for i=1:m(1),	pruef = 0;	for j=1:length(elplist),		if elplist(j)==i,			pruef = 1;			break;		end;	end;	if pruef==0,		nr_electrodes = nr_electrodes + 1;		arg(nr_electrodes) = i;	end;end;if isempty(lfdmat1),	disp('Reading leadfield matrix (lfdmat)');	lfdmat = read_matrix(1965, 129, '/Applications/MATLAB6p5p1/4tools/Libas/4data/lfd129neu.dat');	lfdmat1 = lfdmat';	size(lfdmat)end;if nr_electrodes~=length(lfdmat1(:,1)),   disp(' Resizing and reaveragereferencing leadfield matrix ');   lfdmat = lfdmat1(arg,:);   lfdmat = avg_ref(lfdmat);else   lfdmat = lfdmat1;end;%nr_electrodesdisp('Computing pseudoinverse (G)');G = pinv_tikh(lfdmat, regpar);size(G)if isfrom==0, from=1; to=n(1); end;n(1) = to-from+1;data(:,1:n(1), 1) =  matrix(arg,from:to);data(:,1:n(1), 1) = avg_ref(data(:,1:n(1), 1));m(1)for i=2:nr_names,				% Reading additional files	name = sprintf('%s%s', pathname, namelist(i,:));	disp(name);      [matrix,Version,LHeader,ScaleBins,NChan,NPoints,NTrials,SampRate,AvgRefStatus,File,Path,FilePath,EegMegStatus,NChanExtra,AppFileFormatVal]=...	ReadAppData(FilePath,ActTrial,ActChan,ActPoint,PlotStatus,FilterSpec)        matrix = bslcorr(matrix, bslvec);   [m(i) n(i)] = size(matrix);    if isfrom==0, from=1; to=n(i); end;   n(i) = to-from+1;   data(:,1:n(i), i) =  matrix(arg,from:to);	data(:,1:n(i), i) = avg_ref(data(:,1:n(i), i));	m(i)end;diploc = diploc';[q, r] = when_changes_radius(diploc(1:3,:), 0.001);% Finde Quellenorte nahe den angegebenen Positionen / find source locations% near electrodesfor i=1:length(q),   for j=1:length(locations(1,:)),     if i==1,		% oberste Schicht /outer shell layer         diff(1,:) = diploc(1,1:q(1)) - locations(1,j);            diff(2,:) = diploc(2,1:q(1)) - locations(2,j);         diff(3,:) = diploc(3,1:q(1)) - locations(3,j);         offset = 0;			% Anzahl der Punkte in oberen Schichten /number of points in outer shells     else         	  diff(1,:) = diploc(1,q(i-1)+1:q(i)) - locations(1,j);            diff(2,:) = diploc(2,q(i-1)+1:q(i)) - locations(2,j);         diff(3,:) = diploc(3,q(i-1)+1:q(i)) - locations(3,j);         offset = q(i-1);       end;        	  diff = norm_col(diff);	  [Y,I] = min(diff);     elem(i,j) = offset+I;				% Indizes der nahesten Quellenraumelemente  	  koor(1:3,i,j) = diploc(1:3,elem(i,j)); 	  koor(4,i,j) = Y;     clear diff;   end;end;disp('Computing and writing  inverse solutions (invsol)');   dim = 3;        	for i=1:nr_names,                 if strcmp(out_flag, 'abs'),				filename = [pathout '/' namelist(i,:) '.app.MN'];      	end;      	if strcmp(out_flag, 'rad'),				filename = [pathout '/' namelist(i,:) '.app.rad'];      	end;    AppFid1=fopen([filename '1'],'w','b')	fwrite(AppFid1,Version,'int16');	fwrite(AppFid1,LHeader,'int16');	fwrite(AppFid1,ScaleBins,'int16');	fwrite(AppFid1,NChan,'int16');	fwrite(AppFid1,NPoints,'int16');	fwrite(AppFid1,NTrials,'int16');	fwrite(AppFid1,SampRate,'int16');	fwrite(AppFid1,AvgRefStatus,'int16');		ZeroVec=zeros(LHeader-16,1);	fwrite(AppFid1,ZeroVec,'int8');        AppFid2=fopen([filename '2'],'w','b')	fwrite(AppFid2,Version,'int16');	fwrite(AppFid2,LHeader,'int16');	fwrite(AppFid2,ScaleBins,'int16');	fwrite(AppFid2,NChan,'int16');	fwrite(AppFid2,NPoints,'int16');	fwrite(AppFid2,NTrials,'int16');	fwrite(AppFid2,SampRate,'int16');	fwrite(AppFid2,AvgRefStatus,'int16');		ZeroVec=zeros(LHeader-16,1);	fwrite(AppFid2,ZeroVec,'int8');         AppFid3=fopen([filename '3'],'w','b')	fwrite(AppFid3,Version,'int16');	fwrite(AppFid3,LHeader,'int16');	fwrite(AppFid3,ScaleBins,'int16');	fwrite(AppFid3,NChan,'int16');	fwrite(AppFid3,NPoints,'int16');	fwrite(AppFid3,NTrials,'int16');	fwrite(AppFid3,SampRate,'int16');	fwrite(AppFid3,AvgRefStatus,'int16');		ZeroVec=zeros(LHeader-16,1);	fwrite(AppFid3,ZeroVec,'int8');        AppFid4=fopen([filename '4'],'w','b')	fwrite(AppFid4,Version,'int16');	fwrite(AppFid4,LHeader,'int16');	fwrite(AppFid4,ScaleBins,'int16');	fwrite(AppFid4,NChan,'int16');	fwrite(AppFid4,NPoints,'int16');	fwrite(AppFid4,NTrials,'int16');	fwrite(AppFid4,SampRate,'int16');	fwrite(AppFid4,AvgRefStatus,'int16');		ZeroVec=zeros(LHeader-16,1);	fwrite(AppFid4,ZeroVec,'int8');                        for trial=1:NTrials                        data=ReadAppData(name,trial); % read data       		if strcmp(out_flag, 'abs'),         	inv =  inv_recon(G, data(1:nr_electrodes,1:n(i),i), dim);	         	% Modulo (Intensity map)      		end;     		 if strcmp(out_flag, 'rad'),      		inv = G(3:3:1965,:)*data(1:nr_electrodes,1:n(i),i);			% Radial component      		end;      for j=1:length(q),	      if j==1,	         invsol(:,1:n(i),i) = inv;			               % plot(inv(elem(1,:),1:n(i))')            % pause                          %write_avr(inv(elem(1,:),1:n(i)), filename, 1, 1);			 fwrite(AppFid1,inv(elem(1,:),1:n(i))'.*ScaleBins.*10,'int16');					      elseif j==length(q),	         invsol(:,1:n(i),i) = inv;	       %  write_avr(inv(elem(j,:), 1:n(i)), filename, 1, 1);            fwrite(AppFid4,inv(elem(j,:),1:n(i))'.*ScaleBins.*10,'int16');	          elseif j== 3	         invsol(:,1:n(i),i) = inv;	      %   write_avr(inv(elem(j,:), 1:n(i)), filename, 1, 1);           fwrite(AppFid3,inv(elem(j,:),1:n(i))'.*ScaleBins.*10,'int16');                    elseif j==2               invsol(:,1:n(i),i) = inv;	      %   write_avr(inv(elem(j,:), 1:n(i)), filename, 1, 1);           fwrite(AppFid2,inv(elem(j,:),1:n(i))'.*ScaleBins.*10,'int16');         end;      end %j           % fclose('all')      		end;			% for trial   end;		% i   