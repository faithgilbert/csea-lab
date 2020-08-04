% searches condnumbers in *dat file generated by rdkiaps file
% use Eti's data

function [outmat, condiPNU] = getresponse_rdkETIPNU(filepath);
% can print out all of this...function [ conditionvec, RT, errorvec, onsettime, targetvec, earlylatelabel, picvec, outmat, RTvecEarlyLate, correctvec] = getresponse_rdkETI(filepath);

condvec = []; 

picvec = [];

fid = fopen(filepath)

trialcount = 1;
a = 1;
	
 while a > 0
	
     a = fgetl(fid);
     
     if a < 0, break, return, end
            
     % find the blanks - > so I know where the picture name is 
     blankindices = find(a== ' '); 
     
      conditionTar = deblank(a(blankindices(3)+1)); %target/non-target condition file is after 3rd blank (1, 2, or 3)
      
      targetvec(trialcount) = str2num(conditionTar);
      
      onsettimetemp = deblank(a(blankindices(4):blankindices(4)+2));
      
      onsettime(trialcount) = str2num(onsettimetemp).*133.333 - 133.333;
            
     
     picturestring = (a((blankindices(7)+1:blankindices(7)+2))); %get the picture name info after the 7th blank
     picturestring_long = (a((blankindices(7)+1:blankindices(7)+4))); %get the picture name info after the 7th blank
     picvec = [picvec; picturestring_long];
     
     
     rt(trialcount) = str2num(a(blankindices(6):blankindices(7))) %get the RT info after the 6th blank
     
     
     if rt(trialcount) < 0, rt(trialcount) = rt(trialcount)+ 8600; end %should be 8650?? and add the 4 retraces too 66.6ms    
          
               if picturestring ==  'er', condition(trialcount) = 1;
                elseif picturestring ==  'ct', condition(trialcount) = 2;    
                elseif picturestring ==  'ca', condition(trialcount) = 2;
                elseif picturestring ==  'wr', condition(trialcount) = 3;
                elseif picturestring ==  'wk', condition(trialcount) = 3;
                elseif picturestring ==  'cw', condition(trialcount) = 4;
                elseif picturestring ==  'co', condition(trialcount) = 4; 
                elseif picturestring ==  'mu', condition(trialcount) = 5;
                elseif picturestring ==  'mt', condition(trialcount) = 5;    
                elseif picturestring ==  'sn', condition(trialcount) = 6;
                
                end
      
              trialcount;
 
              
trialcount = trialcount + 1; 
 end % while loop trials
 
 
fclose('all')
  
targetvec = targetvec' .* 100; 

conditionvec = condition' + targetvec; 
  
%conditionvec1to6 = condition'; %condition = picture conditions, 1-3

rt = rt' .*0.001; %change RT into seconds

onsettime = onsettime' .*0.001; %change onset time also into seconds


RT = onsettime-rt; % convert rt relative to picture offset to RT relative to target
% 
% earlylatelabel = zeros(size(RT)); 
% earlylatelabel(find(onsettime>3.750)) = 2;
% earlylatelabel(find(onsettime>1 & onsettime<3.751 & onsettime>0)) = 1;


duringpiclabel  = zeros(size(RT)); 
duringpiclabel(onsettime>3) = 1;


condition = condition' .*100;% condition zero R.Time --> 106.4753 (Cond 1 w/RT = 6.4753 sec)

conditionvecPicRT =[conditionvec  RT]% can use a semi-colon to have the conditionvec and RT values not stacked but side by side 

% %create a vector that has 1s for correct responses, for each trial
indexvec_press = find(RT > .15);
correctvec = zeros(size(condition)); %empty vector to populate
targettrialindices = find(targetvec > 100 & targetvec <  299); %299 excludes the double-flick trials

%  the original code had x2 as = 1 also, but it should be zero...
for x1 = 1:length(correctvec) 
    if ismember(x1,targettrialindices) && ismember(x1,indexvec_press), correctvec(x1) = 1; end %correct response = 1
end
%if its not a target trial and they didn't press after 150 ms, incorrect
for x2 = 1:length(correctvec) 
    if ~ismember(x2,targettrialindices) && ismember(x2,indexvec_press), correctvec(x2) = 0; end %incorrect response = 0 
end

%create a comprehensive output matrix with trial-by-trial data
outmat = [conditionvec RT correctvec]



% find all the responses for each condition
%non-targets
indices_101 = find(conditionvecPicRT(:,1) == 101); response_101 = conditionvecPicRT(indices_101,2); 
indices_102 = find(conditionvecPicRT(:,1) == 102); response_102 = conditionvecPicRT(indices_102,2); 
indices_103 = find(conditionvecPicRT(:,1) == 103); response_103 = conditionvecPicRT(indices_103,2); 
indices_104 = find(conditionvecPicRT(:,1) == 104); response_104 = conditionvecPicRT(indices_104,2);
indices_105 = find(conditionvecPicRT(:,1) == 105); response_105 = conditionvecPicRT(indices_105,2); 
indices_106 = find(conditionvecPicRT(:,1) == 106); response_106 = conditionvecPicRT(indices_106,2); 
%targets
indices_201 = find(conditionvecPicRT(:,1) == 201 & duringpiclabel==1); response_201 = conditionvecPicRT(indices_201,2);
indices_202 = find(conditionvecPicRT(:,1) == 202 & duringpiclabel==1); response_202 = conditionvecPicRT(indices_202,2); 
indices_203 = find(conditionvecPicRT(:,1) == 203 & duringpiclabel==1); response_203 = conditionvecPicRT(indices_203,2); 
indices_204 = find(conditionvecPicRT(:,1) == 204 & duringpiclabel==1); response_204 = conditionvecPicRT(indices_204,2); 
indices_205 = find(conditionvecPicRT(:,1) == 205 & duringpiclabel==1); response_205 = conditionvecPicRT(indices_205,2); 
indices_206 = find(conditionvecPicRT(:,1) == 206 & duringpiclabel==1); response_206 = conditionvecPicRT(indices_206,2); 


%indices_correct_201: find response when CORRECTLY clicked after 150 ms for a TARGET
%meanRT: response time of the correctly ID'd trials 
indices_correct_201 =  find(response_201 > 0.15 & correctvec(indices_201) == 1 & duringpiclabel(indices_201) ==1) ; meanRT_201 = mean(response_201(indices_correct_201));
indices_correct_202 =  find(response_202 > 0.15 & correctvec(indices_202) == 1 & duringpiclabel(indices_202) ==1) ; meanRT_202 = mean(response_202(indices_correct_202));
indices_correct_203 =  find(response_203 > 0.15 & correctvec(indices_203) == 1 & duringpiclabel(indices_203) ==1) ; meanRT_203 = mean(response_203(indices_correct_203));
indices_correct_204 =  find(response_204 > 0.15 & correctvec(indices_204) == 1 & duringpiclabel(indices_204) ==1) ; meanRT_204 = mean(response_204(indices_correct_204));
indices_correct_205 =  find(response_205 > 0.15 & correctvec(indices_205) == 1 & duringpiclabel(indices_205) ==1) ; meanRT_205 = mean(response_205(indices_correct_205));
indices_correct_206 =  find(response_206 > 0.15 & correctvec(indices_206) == 1 & duringpiclabel(indices_206) ==1) ; meanRT_206 = mean(response_206(indices_correct_206));

%mean RT for P, N Un conditions:
% ???

%find FALSE ALARMS (click but no target) for all conditions ; find total number of non-targets for all conditions ; overall percentage of false alarms
%if else loop gives a 0 to any case in which the denominator (# of nontargets) is zero, otherwise NaN

%PLEASANT
fa_p = [find(response_101 > 0.1167); find(response_102 > 0.1167)] ; totnontarg_p = length([indices_101; indices_102]) ;
if totnontarg_p == 0
    pct_fa_p = 0
else
pct_fa_p = (length(fa_p)/totnontarg_p).*100
end 

numfa_p = length(fa_p)
totalfa_p = totnontarg_p

%NEUTRAL
fa_n = [find(response_103 > 0.1167); find(response_104 > 0.1167)] ; totnontarg_n = length([indices_103; indices_104]) ;
if totnontarg_n == 0
    pct_fa_n = 0
else
pct_fa_n = (length(fa_n)/totnontarg_n).*100
end

numfa_n = length(fa_n)
totalfa_n = totnontarg_n

%UNPLEASANT
fa_u = [find(response_105 > 0.1167); find(response_106 > 0.1167)] ; totnontarg_u = length([indices_105; indices_106]) ; 
if totnontarg_u == 0
    pct_fa_u = 0
else
pct_fa_u = (length(fa_u)/totnontarg_u).*100 
end


numfa_u = length(fa_u)
totalfa_u = totnontarg_u


%HITS
hits_p = (length(indices_correct_201) + length(indices_correct_202))/(length(indices_201) + length(indices_202)).*100
corr_p = (length(indices_correct_201) + length(indices_correct_202))
total_p = (length(indices_201) + length(indices_202))

hits_n = (length(indices_correct_203) + length(indices_correct_205))/(length(indices_203) + length(indices_205)).*100
corr_n = (length(indices_correct_203) + length(indices_correct_205))
total_n = (length(indices_203) + length(indices_205))

hits_u = (length(indices_correct_205) + length(indices_correct_206))/(length(indices_205) + length(indices_206)).*100
corr_u = (length(indices_correct_205) + length(indices_correct_206))
total_u = (length(indices_205) + length(indices_206))

% correct rejections
%PLEASANT
if pct_fa_p == 0
    cr_p = 100
else
cr_p = 100 - pct_fa_p
end
% # of trials where Ss correctly rejected the target (1 - FA)
numcr_p = totalfa_p - numfa_p

%NEUTRAL
if pct_fa_n == 0
    cr_n = 100
else
cr_n = 100 - pct_fa_n
end
% # of trials where Ss correctly rejected the target (1 - FA)
numcr_n = totalfa_n - numfa_n

%UNPLEASANT
if pct_fa_u == 0
    cr_u = 100
else
cr_u = 100 - pct_fa_u
end
% # of trials where Ss correctly rejected the target (1 - FA)
numcr_u = totalfa_u - numfa_u

%Overall ACCURACY (hits + correct rejections)
accuracy_p = ((corr_p + numcr_p) / (total_p + totalfa_p)).*100
accuracy_n = ((corr_n + numcr_n) / (total_n + totalfa_n)).*100
accuracy_u = ((corr_u + numcr_u) / (total_u + totalfa_u)).*100

% create PNU vector for EEG

condiPNU = zeros(size(conditionvec)); 
for indexpnu = 1:length(condiPNU); 
    if conditionvec(indexpnu) < 103, condiPNU(indexpnu) = 1; 
    elseif conditionvec(indexpnu) > 102 && conditionvec(indexpnu) < 105, condiPNU(indexpnu) = 2;
    elseif conditionvec(indexpnu) > 104 && conditionvec(indexpnu) < 107, condiPNU(indexpnu) = 3;
    elseif conditionvec(indexpnu) > 199 && conditionvec(indexpnu) < 203, condiPNU(indexpnu) = 1; 
    elseif conditionvec(indexpnu) > 202 && conditionvec(indexpnu) < 205, condiPNU(indexpnu) = 2;
    elseif conditionvec(indexpnu) > 204 && conditionvec(indexpnu) < 207, condiPNU(indexpnu) = 3; 
    end
end
condiPNU
