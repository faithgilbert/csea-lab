% ECG2HRchange
function [BPMstrucmat] = IBI2HRchangemiriam(csvfile)

% for convenience, this reads in the data from an R exported file, where
% one column has timestamps cardiac events, oes has conditions, one has bpm
% obtained from IBIs (we convert them back here, so we have BPMS...)
% determine the proportion of each heart beat for each 1 second-bin. one
% trial after the other
% loop over trials and oncidtions, finds change from one condition 2 next
% and calculates HR change from there as per graham 1979 

oldgainmat = []; 
oldlossmat = []; 
adolesgainmat = []; 
adoleslossmat = [];
younggainmat = [];
younglossmat = [];

m = csvread(csvfile, 2); % reads the spreadsheet into variable m with everything in one go, leaves out labels in first row

% find trials and loop over them 
% 1. find first beat in each new trial/ find index of trial starts
startindexvec = [1; find(diff(m(:,2)) ~=0)+1]; % the first value of course is a start, then use differential of order variable to find where it changes

% loop over trials

for trial = 1:length(startindexvec)-1; 
    
    trial
    
    Rwavestamps = m(startindexvec(trial):startindexvec(trial+1)-1, 11);
    
    agegroup = m(startindexvec(trial), 9);
    gainloss = m(startindexvec(trial), 6);
    
    secbins = [Rwavestamps(1):Rwavestamps(1)+10];
    
    IBIvec = diff(Rwavestamps)
    leftfornext = 0; 
    
    BPMvec = zeros(1,length(secbins)-1);

    % we always start with the first Rwave as the first time bin start

    for bin_index = 1:length(secbins)-1 % start counting timebins with first time bin until second to last, which has info about the last beat(s)

      %find cardiac events in and around this timebin and where they are
      %first find cardiac events that are located entirely in the time bin

      % ---- 
            RindicesInBin1= find(Rwavestamps >= secbins(bin_index));
            RindicesInBin2 = min(find(Rwavestamps > secbins(bin_index +1)));
            RindicesInBin = min(RindicesInBin1) : RindicesInBin2 -1;

            if ~isempty(RindicesInBin); 
            maxbincurrent = max(RindicesInBin);
            end

            if length(RindicesInBin) == 2, % if there are two Rwaves in this segment, the basevalue is always 1 beat, and more may be added

                    basebeatnum = 1+leftfornext;

                     %  identify remaining time and determine proportion of next IBI that belongs to this
                     % segment
                      proportion =  (secbins(bin_index +1) - Rwavestamps(max(RindicesInBin)))./IBIvec(max(RindicesInBin));

                      leftfornext = 1-proportion;

            elseif length(RindicesInBin) == 1,% if there is one Rwave in this segment, the basevalue is what remained from the previous beat, and more may be added

                    basebeatnum = leftfornext;

                     % then identify remaining time and determine proportion of next IBI that belongs to this
                     % segment
                       proportion =  (secbins(bin_index +1) - Rwavestamps(max(RindicesInBin)))./IBIvec(max(RindicesInBin));

                       leftfornext = 1-proportion;

            else % if there is no beat in this segment
                
                basebeatnum = leftfornext;
                
                if length(IBIvec) >= maxbincurrent+1; 
                proportion =  (secbins(bin_index +1) - Rwavestamps(maxbincurrent+1))./IBIvec(maxbincurrent+1);
                else
                    proportion = 1; 
                end

                 leftfornext = abs(proportion);

            end

         BPMvec(bin_index) = (basebeatnum+proportion) .* 60;

    end

    %plot(BPMvec), hold on, 

    % artifact correction

    BPMvec(BPMvec > (mean(BPMvec) + 10) | BPMvec < (mean(BPMvec) - 10)) = mean(BPMvec); 


   % plot(BPMvec, 'r'), pause(.3)
   % hold off

    % assign trial to condition and group
    
    if agegroup == 3 && gainloss == 2; 
      oldgainmat = [oldgainmat;   BPMvec];
    elseif agegroup == 3 && gainloss == 1; 
      oldlossmat = [oldlossmat;   BPMvec]; 
    elseif agegroup == 2 && gainloss == 2; 
      younglossmat = [younglossmat;   BPMvec]; 
    elseif agegroup == 2 && gainloss == 1;
        younggainmat = [younggainmat;   BPMvec]; 
    elseif agegroup == 1 && gainloss == 2;
        adolesgainmat = [adolesgainmat;   BPMvec]; 
    elseif agegroup == 1 && gainloss == 1;
        adoleslossmat = [adoleslossmat;   BPMvec]; 
    end
  

end

BPMstrucmat.oldgain = oldgainmat;
BPMstrucmat.oldloss = oldlossmat;
BPMstrucmat.younggain = younggainmat;
BPMstrucmat.youngloss = younglossmat;
BPMstrucmat.adolesgain = adolesgainmat;
BPMstrucmat.adolesloss = adoleslossmat;




