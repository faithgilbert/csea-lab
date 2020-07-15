% Reads in data from BESA/FOCUS-*.mul-Filesfunction [data, latencies, sample_int, name] = read_mul(filename);if nargin < 1,		%No name specified   	[name, pathname] = uigetfile('*.mul', 'Choose a BESA-*.avr-file!');	filename = sprintf('%s%s', pathname, name)    end;disp(filename);fid = fopen(filename, 'r');line = fgetl(fid)if ~strcmp(line(1:10),'TimePoints'),		% "Traditional" *.avr-header	[dummy, remainder] = strtok(line);	if strcmp(dummy, 'TimePoints=')==0, disp('1This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);			% Number of timepoints (number of columns)	nr_timepoints = str2num(dummy);	[dummy, remainder] = strtok(remainder);	if strcmp(dummy, 'Channels=')==0, disp('2This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);					% Begin of latency range	offset = str2num(dummy);	[dummy, remainder] = strtok(remainder);	if strcmp(dummy, 'BeginSweep[ms]=')==0, disp('3This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);				% Intervall between sample points (ms)	sample_int = str2num(dummy);	[dummy, remainder] = strtok(remainder);	if strcmp(dummy, 'SamplingInterval[ms]=')==0, disp('4This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);					% Number of bins per microvolt	nr_bins = str2num(dummy);	[dummy, remainder] = strtok(remainder);	if strcmp(dummy, 'Bins/uV=')==0, disp('5This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);					% Calibration factor	calib = str2num(dummy);      [dummy, remainder] = strtok(remainder);   if strcmp(dummy, 'Nchan='),      fgetl(fid);			% Skip second line if necessary      [dummy, remainder] = strtok(remainder);					% Calibration factor      nr_channels = str2num(dummy);   end;   	text = sprintf('Timepoints: %d,  Offset: %f,  Sample interval: %f,  Bins: %d,  Calibration: %f', nr_timepoints, offset, sample_int, nr_bins, calib);	disp(text);	latencies = offset:sample_int:(nr_timepoints-1)*sample_int+offset;      data = fscanf(fid, '%f', [nr_timepoints, inf]);   data = data'; else,		% FOCUS *.avr-header              [dummy, remainder] = strtok(line, '=');   dummy2 = deblank(dummy(length(dummy):-1:1));   dummy = dummy2(length(dummy2):-1:1);	if strcmp(dummy, 'TimePoints')==0, disp('1This is not an *.avr-header!!!'); fclose(fid); return; end;   [dummy, remainder] = strtok(remainder);			% Number of timepoints (number of columns)   nr_timepoints = str2num(dummy(2:length(dummy)));      [dummy, remainder] = strtok(remainder, '=');   dummy2 = deblank(dummy(length(dummy):-1:1));   dummy = dummy2(length(dummy2):-1:1);   if strcmp(dummy, 'Channels')==0, disp('2This is not an *.avr-header!!!'); fclose(fid); return; end;   [dummy, remainder] = strtok(remainder);					% Number of channels   nr_channels = str2num(dummy(2:length(dummy)));      [dummy, remainder] = strtok(remainder, '=');   dummy2 = deblank(dummy(length(dummy):-1:1));   dummy = dummy2(length(dummy2):-1:1);   if strcmp(dummy, 'BeginSweep[ms]')==0, disp('3This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);					% Begin of latency range   offset = str2num(dummy(2:length(dummy)));   [dummy, remainder] = strtok(remainder, '=');   dummy2 = deblank(dummy(length(dummy):-1:1));   dummy = dummy2(length(dummy2):-1:1);	if strcmp(dummy, 'SamplingInterval[ms]')==0, disp('4This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);				% Intervall between sample points (ms)   sample_int = str2num(dummy(2:length(dummy)));   [dummy, remainder] = strtok(remainder, '=');   dummy2 = deblank(dummy(length(dummy):-1:1));   dummy = dummy2(length(dummy2):-1:1);	if strcmp(dummy, 'Bins/uV')==0, disp('5This is not an *.avr-header!!!'); fclose(fid); return; end;	[dummy, remainder] = strtok(remainder);					% Number of bins per microvolt	nr_bins = str2num(dummy(2:length(dummy)));	text = sprintf('Timepoints: %d,  NumberChannels: %d,  Offset: %f,  Sample interval: %f,  Bins: %d\n', nr_timepoints, nr_channels, offset, sample_int, nr_bins);	disp(text);   latencies = offset:sample_int:(nr_timepoints-1)*sample_int+offset;      line = fgetl(fid);				% Skip second line   data = fscanf(fid, '%f', [nr_channels, nr_timepoints]);			% Transposed with respect to traditional BESA-format   clear data_vec;end;   fclose(fid);