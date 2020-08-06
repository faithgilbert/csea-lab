% Compute minimum norm solutions on differenct shells of 3D source space, output for different shells separately, output only for specified locations possible

% lfdmat1: Leadfield matrix for given source space and sensor/electrode configuration
% dim: Number of dipole components, e.g. 3 for EEG (x,y,z), 2 for MEG (tangential)
% regpar: Regularization parameter for Tikhonov-Regularization (e.g. chosen by adjusting residual variance)
% paths, names: list of paths and names for datafiles to be analyzed, if paths,names=='': File list can be created via a menu (choose files, then press 'Abbrechen')
% format: input data format, 'avr' for BESA-*.avr-files, 'mfxtxt' for BTI-MFX-ASCII-output (assuming first row elements to be latency values!)
% pathout: Pathname for output of results
% elplist: Channel list with channels to be excluded from calculations. If lfdmat1 has as many rows as there are remaining channels, it is used as it is, otherwise
% the rows specified by elplist are also excluded from lfdmat1 (and lfdmat1 is average referenced for EEG) and output as lfdmat
% locations: 3*nr_points-matrix with locations for which minimum norm values shall be output (e.g. electrode positions) for each shell
% from, to: Range of columns of data matrices to be analyzed, if from,to=='': All columns are included
% out_flag: 'abs': for every location, the modulo of dipole strength is output (only positive values),  'rad': only radial dipole component (EEG) is output (pos. and neg. values) 

function [diploc, lfdmat, data, G, paths, names] = invmap_reduce_find_regpar(lfdmat1, dim, diploc, regpar, paths, names, format, pathout, elplist, locations, from, to, out_flag, extension, noofepochs, ptsperepoch);

if nargin==0,
   disp(' [diploc, lfdmat, data, G, paths, names] = long_invmap_reduce_find_regpar(lfdmat1, dim, diploc, regpar, paths, names, format, pathout, elplist, locations, from, to, out_flag, (extension)); ');
   return;
end;

disp (noofepochs);
disp (ptsperepoch);


if nargin==13,
   extension = '';
end;

chars = '';  	% Number of characters from input filename to be used as output filename, default ('') = all without extension
   
if isempty(names), disp('ERROR: file list empty'); end;

nr_names = length(names(:,1));
for i=1:nr_names,
 namelist(i,1:length(deblank(names(i,:)))+length(deblank(paths(i,:)))) = sprintf('%s%s', deblank(paths(i,:)), deblank(names(i,:)));
end;
   
namelist
[data, latency] = long_read_avr(deblank(namelist(1,:))); 

[nr_electrodes n(1)] = size(data);
latencies(1,1:n(1)) = latency;

%[data, m, n, latencies] = long_read_data(namelist, elplist, format);
nr_names = length(namelist(:,1));
%nr_electrodes = m(1);
text = sprintf('Number of electrodes to be included in the following procedure: %d', nr_electrodes);
disp(text);

if isempty(diploc),	disp('ERROR: dipole locations empty!'); end;
if isempty(lfdmat1), disp('ERROR: leadfield matrix empty!'); end;
if nr_electrodes~=length(lfdmat1(:,1)), disp('ERROR: leadfield matrix and electrodes do not match'); end;
if length(regpar)>1, disp('ERROR: regularisation not given'); end;

lfdmat = lfdmat1;


disp('size of leadfield matrix:');
size(lfdmat)
disp(' Computing pseudoinverse (G) ');
disp('');
G = pinv_tikh(lfdmat, regpar);
disp(size(G));

disp('');
disp(' SKIP: Computing residual variances (0-1) ');
disp('');
%nsum = 0;
%sumvar = 0;
%for i=1:nr_names,
%   inv = G*data(1:m(i),1:n(i),i);
%   variances = res_var(lfdmat, inv, data(1:m(i),1:n(i),i))';
%   minvar(i) = min(variances);
%   maxvar(i) = max(variances);
%   sumvar(i) = sum(variances);
%   nsum = nsum+n(i);
%   text = sprintf('Min: %f   Max: %f   Mean: %f', minvar(i), maxvar(i), sumvar(i)/n(i));
   %tmp_name = deblank(names(i,:));
   %tmp_name = [pathout '/' tmp_name(1:length(tmp_name)-4) extension '.var'];
   %long_write_matrix([latencies(i,1:n(i))', variances(1:n(i))], tmp_name);
   %disp(tmp_name);
%   clear inv;
%end;
%text = sprintf('Over all:    Min: %f   Max: %f   Mean: %f', min(minvar), max(maxvar), sum(sumvar)/nsum); 
%disp(text);


[q, r] = when_changes_radius(diploc(1:3,:), 0.001);

% Finde Quellenorte nahe den angegebenen Positionen 
if ~isempty(locations),
	for i=1:length(q),
   	for j=1:length(locations(1,:)),
     	if i==1,		% oberste Schicht
            diff(1,:) = diploc(1,1:q(1)) - locations(1,j);   
        	diff(2,:) = diploc(2,1:q(1)) - locations(2,j);
	        diff(3,:) = diploc(3,1:q(1)) - locations(3,j);
   	        offset = 0;			% Anzahl der Punkte in oberen Schichten
     	else        
 	  		diff(1,:) = diploc(1,q(i-1)+1:q(i)) - locations(1,j);   
        	diff(2,:) = diploc(2,q(i-1)+1:q(i)) - locations(2,j);
	        diff(3,:) = diploc(3,q(i-1)+1:q(i)) - locations(3,j);
   	        offset = q(i-1);  
	    end;       
	 	diff = norm_col(diff);
		[Y,I] = min(diff);
	   	elem(i,j) = offset+I;				% Indizes der nahesten Quellenraumelemente
	   	if strcmp(out_flag, 'abs')|strcmp(out_flag, 'ori')|strcmp(out_flag, 'oriabs')|strcmp(out_flag, 'absori'),
	        for k=1:dim,
	        	elem_G(i,(j-1)*dim+k) = dim*elem(i,j)-dim+k;
	        end;
	    end;
	    if strcmp(out_flag, 'rad'),
	      	elem_G(i,j) = elem(i,j)*dim;
	    end;
	  	koor(1:3,i,j) = diploc(1:3,elem(i,j));
	 	koor(4,i,j) = Y;
	    clear diff;
	  end;
  end;
end;   

disp('Computing and writing  inverse solutions (invsol)');

	offset = 0;
	for i=1:nr_names,
      j=2;
      %for j=1:length(q),
          
         if (nargin==13)|isempty(chars),
            name = strtok(names(i,:), '.');
         else,
            name = names(i,1:chars);
         end;
         
         if ~isempty(locations),
            rowelem = elem_G(j,:);
         else,
            if j>1, rowelem = dim*q(j-1)+1:dim*q(j);
            else, rowelem = 1:dim*q(1); end;
         end; 
         
         if strcmp(out_flag, 'abs')|strcmp(out_flag, 'absori')|strcmp(out_flag, 'oriabs'),
            %compute the stuff epochwise and append to file
            filename = sprintf('%s/%s_mn%d%s.avr', pathout, name, j, extension);
            disp(filename);   
            fid = fopen(filename, 'w');
            if length(latencies(1,:))>1, interval=latencies(1,2)-latencies(1,1); else, interval = 1; end;
            fprintf(fid, 'Npts= %d  TSB= 0.0  DI= 1.966100  SB= 1.000  SC= 1.0\n', ptsperepoch*noofepochs);

            for k = 0:noofepochs-1,
                %invsolabs = inv_recon(G(rowelem,:), data(1:nr_electrodes,1:n(i),i), dim);
                invsolabs = inv_recon(G(rowelem,:), data(1:nr_electrodes,(k*ptsperepoch)+1:(k*ptsperepoch)+ptsperepoch,i), dim);
                [wrm wrn] = size(invsolabs);
                for wrj=1:wrn,           
                    for wri=1:wrm,
                		fprintf(fid, '%g ', invsolabs(wri,wrj));
                	end;
                	fprintf(fid, '\n');
                end;
            end;
            
            fclose(fid);    
         end;
         
         if strcmp(out_flag, 'ori')|strcmp(out_flag, 'absori')|strcmp(out_flag, 'oriabs'),
           % parameters for wavelet
           SampRate = 1000 / 1.9661

           delta_f0 = 2
           f0_start = 8
           f0_end = 90

           % Npoints runden auf naechste 2erpotenz eg 458 -> 512
           NPointsNew = 2;
           potsize = 2;
           while NPointsNew < ptsperepoch;
            potsize = potsize + 1;
            NPointsNew = 2^potsize;
           end

           % render wavelet  
           wavelet = gener_wav(NPointsNew, delta_f0, f0_start, f0_end); 
           
           %disp(['size of wavelet ' size(wavelet)]);
           %SumPower1 = zeros(197, size(wavelet, 1), ptsperepoch);
           %SumRayleigh1 = zeros(197, size(wavelet, 1), ptsperepoch);
           %SumPower2 = zeros(197, size(wavelet, 1), ptsperepoch);
           %SumRayleigh2 = zeros(197, size(wavelet, 1), ptsperepoch);
           AvgWaPower = zeros(197, size(wavelet, 1), ptsperepoch);
           AvgWaPower1 = zeros(197, size(wavelet, 1), ptsperepoch);
           AvgWaPower2 = zeros(197, size(wavelet, 1), ptsperepoch);
           PhasLockfac = zeros(197, size(wavelet, 1), ptsperepoch);
           PhasLockfac1 = zeros(197, size(wavelet, 1), ptsperepoch);
           PhasLockfac2 = zeros(197, size(wavelet, 1), ptsperepoch);
           
           for epx = 0:noofepochs-1, 
             tic;
             fprintf('epoch nr: %g \n', epx);             
               
             % render mn solution for both oris  
             tmp = inv_recon(G(rowelem,:), data(1:nr_electrodes,(epx*ptsperepoch)+1:(epx*ptsperepoch)+ptsperepoch,i), 1);
             for k=1:dim,
                invsolori(1:length(rowelem)/dim,k:dim:dim*ptsperepoch) = tmp(k:dim:length(rowelem), 1:ptsperepoch);
             end;
             clear tmp;
           
             % render wavelet for first ori
             [zeilen spalten]=size(invsolori);
             for jump=1 : 2 : spalten;
               invsolori1(:,(round(jump/2)))=invsolori(:,jump);
             end;
             for jump=2:2:spalten;
               invsolori2(:,((jump/2)))=invsolori(:,jump);
             end;
             clear invsolori;
             
             fprintf('  orientation: 1 '); 
             
             for chnlz = 1 :  zeilen;
 
              [AvgWaPower(chnlz,:,:), PhasLockfac(chnlz,:,:)]=wa_new([invsolori1(chnlz,:)'; zeros(NPointsNew-ptsperepoch,1)], wavelet, NPointsNew, delta_f0, f0_start, f0_end, ptsperepoch);
               
             end; % electrodes chnlz

             AvgWaPower1 = AvgWaPower1 + AvgWaPower;
             PhasLockfac1 = PhasLockfac1 + PhasLockfac;
             %fprintf(' rayleigh min: %f', min(PhasLockfac));
             %fprintf(' rayleigh max: %f', max(PhasLockfac));                    
             
            
             % render wavelet for second ori
             fprintf('2 '); 
             
             for chnlz = 1 :  zeilen;
       
              [AvgWaPower(chnlz,:,:),PhasLockfac(chnlz,:,:)]=wa_new([invsolori2(chnlz,:)'; zeros(NPointsNew-ptsperepoch,1)], wavelet, NPointsNew, delta_f0, f0_start, f0_end, ptsperepoch);
              
             end; % electrodes chnlz

             AvgWaPower2 = AvgWaPower2 + AvgWaPower;
             PhasLockfac2 = PhasLockfac2 + PhasLockfac;        
             %fprintf(' rayleigh min: %f', min(PhasLockfac));
             %fprintf(' rayleigh max: %f', max(PhasLockfac));
             elti = toc;
             fprintf(' elapsed time %f\n', elti);
         end; % epx
           
           AvgWaPower1 = AvgWaPower1 ./noofepochs;
           PhasLockfac1 = abs(PhasLockfac1 ./noofepochs);
           AvgWaPower2 = AvgWaPower2 ./noofepochs;
           PhasLockfac2 = abs(PhasLockfac2 ./noofepochs);
           
           fprintf('z-transforming rayleighs\n'); 
           tic;
           for chnlz = 1 :  zeilen;
               AvgWaPower(chnlz,:,:) = sqrt(AvgWaPower1(chnlz,:,:) .^2 + AvgWaPower2(chnlz,:,:) .^2);
               PhasLockfac(chnlz,:,:) = matrix_ruecktrans((ztrans(squeeze(PhasLockfac1(chnlz,:,:))) + ztrans(squeeze(PhasLockfac2(chnlz,:,:))))./2); 

           end; %chnlz
           
           elti = toc;
           fprintf(' elapsed time %f\n', elti);
          
           %bcAvgWaPower = bslcorrWAMat(AvgWaPower, [30:50]);
           %contourf(squeeze(bslmat(12, :, :)));
           
           filename = sprintf('%s/%s_mn%d%s', pathout, name, j, extension);
           %eval([' save ' [filename]  '.wa.mat  bcAvgWaPower -mat'])
           eval([' save ' [filename]  '.wa.mat  AvgWaPower -mat'])
           eval([' save ' [filename]  '.RA.mat  PhasLockfac -mat'])
           clear invsolori1;           
           clear invsolori2;
           clear invsolori;
           clear AvgWaPower;
           clear PhasLockfac;
      	 end;
          
          %end;			% j
   end;		% i
   
   