% svmclassify_dotprobe
%%
% if necessary
       load('alltrials_falsebel.mat')
       load('alltrials_falsecomp.mat')

% Load the data and select features for classification

clf, figure(21),  grid on
pause(1)

opstru = statset;
opstru.MaxIter = 25000; 

clear err_rate; 

for run = 1:300

% select random section of data: 400 (each for condition1 and condition 2) out of 421 
% remaining 100 (each for fast and slow) for test

a = randperm(421, 400); 
b = find(~ismember(1:421, a));

labelstrain = [zeros(400,1) ; ones(400,1)];
labelstest = [zeros(21,1); ones(21,1)];
 
% features
 count = 1; 
 
 for timepoint = 1:100:1100; 
   
    % channelmat = [ones(257,1).*126 column(1:257)]; 
    channelmat = 1:20:257; 
     
     for channelindex = 1:1
         
         channel = channelmat(channelindex,:); 
     
            Xtrain = [squeeze(mean(alltrials_falsebel(channel,[timepoint:timepoint+50],a), 2))'; squeeze(mean(alltrials_falsecomp(channel,[timepoint:timepoint+50],a), 2))']; 
            Xtest = [squeeze(mean(alltrials_falsebel(channel,[timepoint:timepoint+50],b), 2))'; squeeze(mean(alltrials_falsecomp(channel,[timepoint:timepoint+50],b), 2))'];  

            Xtrain = z_norm(Xtrain); 
            Xtest = z_norm(Xtest); 
            %size(Xtrain)
            % Use a linear support vector machine classifier
            %
            % svmStruct = svmtrain(Xtrain,labelstrain,'showplot',true);
            svmStruct = svmtrain(Xtrain,labelstrain, 'options', opstru);

            %C = svmclassify(svmStruct,Xtest,'showplot',true);
            C = svmclassify(svmStruct,Xtest);

            err_rate(channelindex, count, run) = sum(labelstest~= C)/42; % mis-classification rate
            % conMat = confusionmat(labelstest,C); % the confusion matrix
            % end  
     end
       count = count+ 1; if round(count./20) == count./20, disp (count), end
 end

 disp('run: '), disp(run), plot(squeeze(err_rate(:, run))), title(num2str(run)), pause(1),  grid on, hold on,
end

%% RANDOM classification with flipped labels
% if necessary
 %      load fastmat3d.mat
 %      load slowmat3d.mat

% Load the data and select features for classification
clf, figure(21),  grid on
pause(1)

opstru = statset;
opstru.MaxIter = 25000; 

clear err_rate; 

for run = 1:300


% select random section of data: 804 (each for fast and slow) out of 904 
% remaining 100 (each for fast and slow) for test

a = randperm(904, 804); 
b = find(~ismember(1:904, a));

labelstrain = [zeros(804,1) ; ones(804,1)];
labelstest = [zeros(100,1); ones(100,1)];
 
% features
 count = 1; 
 
 for timepoint = 1:5:1350; 
 
     channel = [62 55 ]; 

      
Xtrain = [squeeze(mean(fastmat3d(channel,[timepoint:timepoint+50],a), 2))'; squeeze(mean(slowmat3d(channel,[timepoint:timepoint+50],a), 2))']; 
Xtest = [squeeze(mean(fastmat3d(channel,[timepoint:timepoint+50],b), 2))'; squeeze(mean(slowmat3d(channel,[timepoint:timepoint+50],b), 2))'];  
  
%size(Xtrain)
% Use a linear support vector machine classifier
%
% svmStruct = svmtrain(Xtrain,labelstrain,'showplot',true);
svmStruct = svmtrain(Xtrain,labelstrain, 'options', opstru);


% this for RANDOM clssification 
%C = svmclassify(svmStruct,Xtest,'showplot',true);
labelstest = labelstest(randperm(200)); 
C = svmclassify(svmStruct,Xtest);

err_rate(count, run) = sum(labelstest~= C)/200; % mis-classification rate
% conMat = confusionmat(labelstest,C); % the confusion matrix
% end  

 count = count+ 1; if round(count./20) == count./20, disp (count), end
 end
 disp('run: '), disp(run), plot(squeeze(err_rate(:, run))), title(num2str(run)), pause(1),  grid on, hold on,
end