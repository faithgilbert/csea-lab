function ft_taggingfindmax(cfg, targfreq, distfreq)

% looks for best electrode when given two frequencies, plots an array of
% spectra
%
% Use as
%   ft_realtime_powerestimate(cfg)
% with the following configuration options
%   cfg.channel    = cell-array, see FT_CHANNELSELECTION (default = 'all')
%   cfg.foilim     = [Flow Fhigh] (default = [0 120])
%   cfg.blocksize  = number, size of the blocks/chuncks that are processed (default = 1 second)
%   cfg.bufferdata = whether to start on the 'first or 'last' data that is available (default = 'last')
%
% The source of the data is configured as
%   cfg.dataset       = string
% or alternatively to obtain more low-level control as
%   cfg.datafile      = string
%   cfg.headerfile    = string
%   cfg.eventfile     = string
%   cfg.dataformat    = string, default is determined automatic
%   cfg.headerformat  = string, default is determined automatic
%   cfg.eventformat   = string, default is determined automatic
%
% To stop the realtime function, you have to press Ctrl-C

% Copyright (C) 2008, Robert Oostenveld
%
% Subversion does not use the Log keyword, use 'svn log <filename>' or 'svn -v log | less' to get detailled information

% set the default configuration options
if ~isfield(cfg, 'dataformat'),     cfg.dataformat = [];      end % default is detected automatically
if ~isfield(cfg, 'headerformat'),   cfg.headerformat = [];    end % default is detected automatically
if ~isfield(cfg, 'eventformat'),    cfg.eventformat = [];     end % default is detected automatically
if ~isfield(cfg, 'blocksize'),      cfg.blocksize = .5;        end % in seconds
if ~isfield(cfg, 'channel'),        cfg.channel = 'all';      end
if ~isfield(cfg, 'foilim'),         cfg.foilim = [0 120];     end
if ~isfield(cfg, 'bufferdata'),     cfg.bufferdata = 'last';  end % first or last

% translate dataset into datafile+headerfile
if ~isfield(cfg, 'dataset') && ~isfield(cfg, 'header') && ~isfield(cfg, 'datafile')
  cfg.dataset = 'buffer://localhost:1972';
end
cfg = ft_checkconfig(cfg, 'dataset2files', 'yes');
cfg = ft_checkconfig(cfg, 'required', {'datafile' 'headerfile'});

% ensure that the persistent variables related to caching are cleared
clear ft_read_header
% start by reading the header from the realtime buffer
hdr = ft_read_header(cfg.headerfile, 'cache', true, 'retry', true);

% define a subset of channels for reading
cfg.channel = ft_channelselection(cfg.channel, hdr.label);
chanindx    = match_str(hdr.label, cfg.channel);
nchan       = length(chanindx);
if nchan==0
  error('no channels were selected');
end

% determine the size of blocks to process
blocksize = round(cfg.blocksize * hdr.Fs);

% this is an empty vector of max electrodes
targmaxelcvec = []; 

% this is used for scaling the figure
powmax = 0;

% set up the lowpass filter at 40 Hz and highpass at 5 Hz

  [Blow,Alow] = butter(3, 40/(hdr.Fs/2)); 
    
  [Bhigh,Ahigh] = butter(3, 5/(hdr.Fs/2), 'high'); 
	

% enter the loop 
prevSample  = 0;
count       = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the general BCI loop where realtime incoming data is handled
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while true

  % determine number of samples available in buffer
  hdr = ft_read_header(cfg.headerfile, 'cache', true);

  % see whether new samples are available
  newsamples = (hdr.nSamples*hdr.nTrials-prevSample);

  if newsamples>=blocksize

    % determine the samples to process
    if strcmp(cfg.bufferdata, 'last')
      begsample  = hdr.nSamples*hdr.nTrials - blocksize + 1;
      endsample  = hdr.nSamples*hdr.nTrials;
    elseif strcmp(cfg.bufferdata, 'first')
      begsample  = prevSample+1;
      endsample  = prevSample+blocksize ;
    else
      error('unsupported value for cfg.bufferdata');
    end

    % remember up to where the data was read
    prevSample  = endsample;
    count       = count + 1;
    fprintf('processing segment %d from sample %d to %d\n', count, begsample, endsample);

    % read data segment from buffer
    dat = ft_read_data(cfg.datafile, 'header', hdr, 'begsample', begsample, 'endsample', endsample, 'chanindx', chanindx, 'checkboundary', false);
    datsize = size(dat); 
    
    % flip and filter
    dat = dat'; 
    lowpasssig = filtfilt(Blow,Alow, dat); 
    lowhighpasssig = filtfilt(Bhigh, Ahigh, lowpasssig);
    dat = lowhighpasssig'; 
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % from here onward it is specific to the power estimation from the data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % put the data in a fieldtrip-like raw structure
    data.trial{1} = dat';
    data.time{1}  = offset2time(begsample, hdr.Fs, endsample-begsample+1);
    data.label    = hdr.label(chanindx);
    data.hdr      = hdr;
    data.fsample  = hdr.Fs;
    data.label;

    % apply preprocessing options first high then lowpass
   % data.trial{1} = ft_preproc_baselinecorrect(data.trial{1});
   
    %figure(5)
    %plot (data.trial{1})

    figure(1)
    h = get(gca, 'children');
    hold on

    if ~isempty(h)
      % done on every iteration
      delete(h);
    end

    if isempty(h)
      % done only once
      powmax = 0;
      grid on
    end
  size(data.trial{1}) 
  data.fsample
    
    [pow, freqs] = FFT_spectrum(data.trial{1}', data.fsample);
    
    %calculate the frequencies, the differences, and the tone
    % first extract the frequencies of interest
    targindex = find(round(freqs) == targfreq);
    distindex = find(round(freqs) == distfreq);
    
  
    %find electrode with max targetfreq
   targmaxelc =  find(pow(:,targindex) == max(pow(:,targindex)));
   distmaxelc  = find(pow(:,distindex) == max(pow(:,distindex))'); 
   
    
   for rowindex = 1: size(pow,1)
       if rowindex == targmaxelc
            subplot(size(pow,1),1, rowindex); plot(pow(rowindex,:), 'r'), axis([cfg.foilim(1) cfg.foilim(2) 0 max(max(pow))]); ylabel(num2str(rowindex)); 
       else
           subplot(size(pow,1),1, rowindex); plot(pow(rowindex,:)), axis([cfg.foilim(1) cfg.foilim(2) 0 max(max(pow))]); ylabel(num2str(rowindex)); 
       end
   end
    
       

    %str = sprintf('time = %d s\n', round(mean(data.time{1})));
    %title(str);
    
    xlabel('frequency (Hz)');
    ylabel('power');

    % force Matlab to update the figure
    drawnow
    
    targmaxelcvec = [targmaxelcvec targmaxelc]; figure(2), plot(targmaxelcvec)

  end % if enough new samples
end % while true

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [time] = offset2time(offset, fsample, nsamples)
offset   = double(offset);
nsamples = double(nsamples);
time = (offset + (0:(nsamples-1)))/fsample;