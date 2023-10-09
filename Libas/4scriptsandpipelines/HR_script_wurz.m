
%% this is how the HR time series were generated


%% this is the postprocessing section
clc
filemat = getfilesindir(pwd, '*app1*mat'); 

groupBPM = []; 

for fileindex = 1:size(filemat,1) 

    temp = load(deblank(filemat(fileindex,:))); 

    trialBPM = movmean(temp.BPMmat(:, 3:end), 5, 2);

    stdvec = std(trialBPM'); 

    badindex = find(stdvec>5);  
    
    avgBPM = mean(trialBPM); 

    trialBPM(badindex, :) = nan(size(trialBPM(badindex, :))); 

    trialBPM(end, :) = avgBPM; 
    
    avgBPM = nanmean(trialBPM); 

    groupBPM(fileindex,:) = avgBPM; 

    plot(trialBPM'), title(deblank(filemat(fileindex,:))), hold on, plot(avgBPM, 'k', 'LineWidth', 4), pause, hold off

end
   disp('done')

groupBPM3 = groupBPM;

%% this is for plotting and baseline correction 
taxis = -.5:.5:9.5;
groupBPM1bsl = bslcorr(groupBPM1, 1);
groupBPM2bsl = bslcorr(groupBPM2, 1);
groupBPM3bsl = bslcorr(groupBPM3, 1);
figure, hold on
plot(taxis, mean(groupBPM3bsl), 'g', 'LineWidth', 4)
plot(taxis,mean(groupBPM2bsl), 'm', 'LineWidth', 4)
plot(taxis,mean(groupBPM1bsl), 'r', 'LineWidth', 4)  

