function [dataout] = shreadpostpro(datfilepath, setfilepath_p, setfilepath_i)

%eeglab  % open eeglab

PLImat = [];

[convec] = SHREAD_getcontrial(datfilepath);  % get conditions in experiment, there can be various numbers of trials

% load the EEG for parent and infant 
EEG_p = pop_loadset(setfilepath_p);
EEG_i = pop_loadset(setfilepath_i);

% how many trials in each
trialsinEEG_p = size(EEG_p.epoch, 2);
trialsinEEG_i = size(EEG_i.epoch, 2);

% find common trials and indices
for x1 = 1:trialsinEEG_p
indexinEEG_p(x1) = str2num(EEG_p.epoch(x1).eventdescription)
end

for x2 = 1:trialsinEEG_i
indexinEEG_i(x2) = str2num(EEG_i.epoch(x2).eventdescription);
end

commontrials = intersect(indexinEEG_p, indexinEEG_i)

% now find these common trials in each file and make into one matrix
dataout = []; 
for x3 = 1:size(commontrials, 2)

    %find trials with that original index, i.e trials tha belong together
     index_p = find(commontrials(x3)==indexinEEG_p)
     index_i = find(commontrials(x3)==indexinEEG_i)

     temp_p = EEG_p.data(:, :, index_p); 
     temp_i = EEG_i.data(:, :, index_i); 

     dataout(:, :, x3) = [temp_p;temp_i]; 

end

% find conditions for each trial and make submatrices





