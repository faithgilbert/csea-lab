% lfdmat1: Leadfield-Matrix fuer Sensor- und Dipolkonfiguration% regpar: Regularisierungsparameter ("je groesser, desto glatter", Erfahrungswerte:1<regpar<1000)% pathname: Pfadname fuer *.avr-Datei% namelist: Liste mit *.avr-Dateien (mit Endung!), z.B.: namelist = char('dat1.avr', 'dat2.avr')% pathout: Ausgabepfad, Dateinamen bestehen aus ersten drei Buchstaben der namelist-Namen, +mn[1,2,3...] (oder mnrad[1,2,3...])% elplist: Auszuschliessende Elektroden, z.B. elplist = [44, 61], oder elplist=''% from, to: Zu bearbeitende Spalten der Datenmatrix% out_flag: 'abs'=>Betraege der Dipolmomente (>0), 'rad'=>Radialteile der Dipolmomentefunction [diploc, lfdmat, data, G, invsol] = invmap(lfdmat1, regpar, pathname, namelist, pathout, elplist, from, to, out_flag);if nargin==0,   disp(' [diploc, lfdmat, data, G, invsol] = invmap(lfdmat, regpar, pathname, namelist, pathout, elplist, from, to, out_flag); ');   return;end;isfrom = 1;if isempty(from),   isfrom=0;end;nr_names = length(namelist(:,1)); disp('Reading in data, average referencing');name = sprintf('%s\\%s', pathname, namelist(1,:));disp(name);[matrix, latencies] = read_avr(name);[m(1) n(1)] = size(matrix)disp(' Determine valid electrodes to be included in the following procedure');nr_electrodes = 0;for i=1:m(1),	pruef = 0;	for j=1:length(elplist),		if elplist(j)==i,			pruef = 1;			break;		end;	end;	if pruef==0,		nr_electrodes = nr_electrodes + 1;		arg(nr_electrodes) = i;	end;end;nr_electrodesif isfrom==0, from=1; to=n(1); end;n(1) = to-from+1;data(:,1:n(1), 1) =  matrix(arg,from:to);data(:,1:n(1), 1) = avg_ref(data(:,1:n(1), 1));m(1)for i=2:nr_names,				% Reading in additional files	name = sprintf('%s\\%s', pathname, namelist(i,:));	disp(name);   [matrix, latencies] = read_avr(name);   [m(i) n(i)] = size(matrix);    if isfrom==0, from=1; to=n(i); end;   n(i) = to-from+1;   data(:,1:n(i), i) =  matrix(arg,from:to);	data(:,1:n(i), i) = avg_ref(data(:,1:n(i), i));	m(i)end;disp('Reading dipole locations (diploc)');diploc = read_matrix(1384, 3, 'c:\users\Andreas\leadfield\diploc_sph_08_02_01_-06.dat');diploc = diploc';if isempty(lfdmat1),	disp('Reading leadfield matrix (lfdmat)');	lfdmat1 = read_matrix(4152, 21, 'c:\Matlab\analysis\elp\lead21_pol_08_02_01_-06.dat');	lfdmat1 = lfdmat1';	size(lfdmat1)else   lfdmat = lfdmat1;end;if nr_electrodes~=length(lfdmat1(:,1)),   lfdmat = lfdmat1(arg,:);   lfdmat = avg_ref(lfdmat);end;    disp('Computing pseudoinverse (G)');G = pinv_tikh(lfdmat, regpar);size(G)[q, r] = when_changes_radius(diploc, 0.001);disp('Computing and writing  inverse solutions (invsol)');   dim = 3;	for i=1:nr_names,      if strcmp(out_flag, 'abs'),         inv =  inv_recon(G, data(1:nr_electrodes,1:n(i),i), dim);		% Modulo (Intensity map)      end;      if strcmp(out_flag, 'rad'),      	inv = G(3:3:4152,:)*data(1:nr_electrodes,1:n(i),i);			% Radial component      end;      for j=1:length(q),         if strcmp(out_flag, 'abs'),				filename = sprintf('%s\\%smn%d.avr', pathout, namelist(i,1:3), j);      	end;      	if strcmp(out_flag, 'rad'),				filename = sprintf('%s\\%smnrad%d.avr', pathout, namelist(i,1:3), j);      	end;			disp(filename);	      fid = fopen(filename, 'w');	      if j==1,	         volume = (4.0/3.0)*pi*(r(1)^3-r(2)^3)/q(1);	         inv(1:q(1),1:n(i)) = inv(1:q(1),1:n(i))/volume;	         invsol(:,1:n(i),i) = inv;	         write_avr(inv(1:q(1),1:n(i)), filename, 1, 1);	      elseif j==length(q),	         volume = (4.0/3.0)*pi*(r(j)^3)/q(j);	         inv(q(j-1)+1:length(diploc(1,:))) = inv(q(j-1)+1:length(diploc(1,:)))/volume;	         invsol(:,1:n(i),i) = inv;	         write_avr(inv(q(j-1)+1:length(diploc(1,:)), 1:n(i)), filename, 1, 1);	      else	         volume = (4.0/3.0)*pi*(r(j)^3-r(j+1)^3)/q(j);        	         inv(q(j-1)+1:q(j), 1:n(i)) = inv(q(j-1)+1:q(j), 1:n(i))/volume;	         invsol(:,1:n(i),i) = inv;	         write_avr(inv(q(j-1)+1:q(j), 1:n(i)), filename, 1, 1);			end;		end;			% j   end;		% i      