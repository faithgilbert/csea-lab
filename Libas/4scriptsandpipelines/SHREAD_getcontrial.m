function [convec] = SHREAD_getcontrial(filepath)

%filepath ='/Users/nicholasdroche-cerdan/Dropbox (UFL)/SHREAD/SHREAD_dat files/SHREAD_SSVEP_01.dat'

condition = []; 

fid = fopen(filepath); 
condvec = []; 
trialcount = 1;
a = 1;

while a > 0
	
     a = fgetl(fid);
     
     if a < 0, break, return, end
         
       
    book = str2num(a(3:4)) % looks like it has to be the 4th not the 3rd
    
        index1 = findstr(a, '.jpg');
        imgname1 = strtok(a(index1(1)-4:index1(1)-1)) % deblank only removes blanks at the end
        index2 = index1(2);
        imgname2 = strtok(a(index2-4:index2-1)) % deblank only removes blanks at the end

% this won't work: if imgname1 == 'sh2f' && imgname2 == 'sh6', end % just to illustrate that using == is not good for strings. If they have unequal length, will result in  
% one logical outputr per letter, try strcmp(imgname1,  'sh2f' for example. 

        if book ==1  
                if strcmp(imgname1, 'aa1f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aj2') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aj3') || ...
                strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aj2') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aj3')...
                || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aj2') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aj3'), condition(trialcount) = 101; %within trained: individual vs no label


                elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aj3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aj3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aj3'), condition(trialcount) = 102; %within trained: category vs. no label
               
                
             elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sh3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sh3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sh3'), condition(trialcount) = 103; %within trained: individual vs category
               
                
             elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd3'), condition(trialcount) = 104; %trained vs untrained different: individual 
               
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai3')... % typo corrected a13 -> ai3
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai3'), condition(trialcount) = 105; %trained vs untrained different: category 
             
           elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa3'), condition(trialcount) = 106; %trained vs untrained different: no label 
               
             elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab3'), condition(trialcount) = 107; %trained vs untrained similar: individual 
               
             elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg3'), condition(trialcount) = 108; %trained vs untrained similar: category 
               
             elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac3'), condition(trialcount) = 109; %trained vs untrained similar: no label 
               
             elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aa6')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aa6')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aa6'), condition(trialcount) = 110; %trained vs untrained withn species: individual
             
                 
             elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sh6')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sh6')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sh6'), condition(trialcount) = 111; %trained vs untrained withn species: category
             
             elseif strcmp(imgname1,  'aj1') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj1') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj1') && strcmp(imgname2,'aj6')...
                 ||strcmp(imgname1,  'aj2') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj2') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj2') && strcmp(imgname2,'aj6')... 
                 ||strcmp(imgname1,  'aj3') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj3') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj3') && strcmp(imgname2,'aj6'), condition(trialcount) = 112; %trained vs untrained withn species: no label
                end %if loop book 1
                
        elseif book == 2
                if strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sh3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sh3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sh3'), condition(trialcount) = 201; %within trained: individual vs no label
                
             elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sh3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sh3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sh1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sh2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sh3'), condition(trialcount) = 202; %within trained: category vs no label
               
             elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aa3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aa3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aa3'), condition(trialcount) = 203; %within trained: individual vs category
             
            elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa3'), condition(trialcount) = 204; %%trained vs untrained different: individual 
             
            elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd3'), condition(trialcount) = 205; %trained vs untrained different: category
             
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai3'), condition(trialcount) = 206; %trained vs untrained different: no label
               
            elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac3'), condition(trialcount) = 207; %trained vs untrained similar: individual
             
            elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab3'), condition(trialcount) = 208; %trained vs untrained similar: category
             
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg3'), condition(trialcount) = 209; %trained vs untrained similar: no label
             
                elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj6')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj4') || strcmp(imgname1, 'aj2f') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj6')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj6'), condition(trialcount) = 210; %trained vs untrained within species: invidual
             
           elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'aa6')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'aa6')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'aa6'), condition(trialcount) = 211; %trained vs untrained within species: category
             
           elseif strcmp(imgname1,  'sh1') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh1') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh1') && strcmp(imgname2,'sh6')...
                 ||strcmp(imgname1,  'sh2') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh2') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh2') && strcmp(imgname2,'sh6')... 
                 ||strcmp(imgname1,  'sh3') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh3') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh3') && strcmp(imgname2,'sh6'), condition(trialcount) = 212; %trained vs untrained within species: no label
                end %if loop book 2
        elseif book ==3
            if strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aa3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aa3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aa3'), condition(trialcount) = 301; %within trained: individual vs. no label
              
            elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aa3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aa3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aa1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aa2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aa3'), condition(trialcount) = 302; %within trained: category vs. no label
            
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'aj3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'aj3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'aj3'), condition(trialcount) = 303; %within trained: individual vs. category
            
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ai3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ai3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ai3'), condition(trialcount) = 304; %trained vs untrained different: individual
           
            elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'sa3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'sa3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'sa3'), condition(trialcount) = 305; %trained vs untrained different: category
          
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sd2')... % @@@ added by AK !!!!! :-) 
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sd3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sd3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sd3'), condition(trialcount) = 306; %trained vs untrained different: no label
             
           elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'sd3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'sd3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'sd3'), condition(trialcount) = 306; %trained vs untrained different: no label
            
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sg3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sg3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sg3'), condition(trialcount) = 307; %trained vs untrained similar: individual
           
            elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'ac3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'ac3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'ac3'), condition(trialcount) = 308; %trained vs untrained similar: category
            
            elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj5')... % @@@ added by AK !!!!! :-) !!!! fun! 
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj6')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj6')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj4') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj5')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj6'), condition(trialcount) = 308; %trained vs untrained similar: category
            
            elseif strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa1f') && strcmp(imgname2,'ab3')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa2f') && strcmp(imgname2,'ab3')... 
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'aa3f') && strcmp(imgname2,'ab3'), condition(trialcount) = 309; %trained vs untrained similar: no label
             
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ab2')...  % @@@ added by AK !!!!! :-) !!!! fun! 
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'ab3')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'ab3')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ab1') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ab2')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'ab3'), condition(trialcount) = 309; %trained vs untrained similar: no label
          
            elseif strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh1f') && strcmp(imgname2,'sh6')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh2f') && strcmp(imgname2,'sh6')... 
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sh4') || strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sh5')...
                 ||strcmp(imgname1,  'sh3f') && strcmp(imgname2,'sh6'), condition(trialcount) = 310; %trained vs untrained within species: invidual
           
           elseif strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'aj1f') && strcmp(imgname2,'aj3')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'aj2f') && strcmp(imgname2,'aj3')... 
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj1') || strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj2')...
                 ||strcmp(imgname1,  'aj3f') && strcmp(imgname2,'aj3'), condition(trialcount) = 311; %trained vs untrained within species: category
           
           elseif strcmp(imgname1,  'aa1') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa1') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa1') && strcmp(imgname2,'aa6')...
                 ||strcmp(imgname1,  'aa2') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa2') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa2') && strcmp(imgname2,'aa6')... 
                 ||strcmp(imgname1,  'aa3') && strcmp(imgname2,'aa4') || strcmp(imgname1,  'aa3') && strcmp(imgname2,'aa5')...
                 ||strcmp(imgname1,  'aa3') && strcmp(imgname2,'aa6'), condition(trialcount) = 312; %trained vs untrained within species: no label
             
            end %if loop book 3
        end %block loop
        condition(trialcount)
        trialcount = trialcount + 1

    
end %while loop
       
convec= condition'; 


