%fixconfile
%fixes a confile with missing triggers from the gaborgen experiment
function[outvec, convec]=fixconfile(copyconfile,blocknum);

hab_codes=[6,2,5,1,7,8,4,3,4,7,3,6,8,2,1,5,5,6,2,7,3,8,1,4,4,2,5,1,8,7,6,3,2,3,8,4,7,1,5,6,7,2,4,3,8,1,6,5,7,2,5,8,4,3,6,1,4,8,7,6,5,1,2,3];
acq_codes=[2,3,7,5,1,4,6,8,1,7,4,6,8,5,2,3,8,4,6,7,2,5,1,3,5,3,8,7,6,2,1,4,3,5,4,6,7,1,8,2,6,5,2,8,7,4,3,1,4,8,6,2,7,3,5,1,5,6,7,4,1,8,2,3];
ext_codes=[8,5,6,7,4,3,1,2,8,4,6,7,2,1,5,3,5,2,7,8,4,1,3,6,4,8,2,7,5,6,1,3,6,7,4,2,3,5,1,8,5,1,4,7,8,3,2,6,5,4,1,8,6,3,2,7,5,6,1,4,7,2,8,3];

if blocknum==1 || blocknum==3 % hab and ext blocks

    %1st:readconfile

    [timevec]=readconfile(copyconfile);%copy of confile,in which the first block(with con nums) is deleted

    figure

    plot(diff(timevec))

    onsetindexvec=find(diff(timevec)<600&diff(timevec)>500);         %find indices of trigs where pics begin - 
                                                                                                        %physiotrig to pic oneset always +500 sp
           length(onsetindexvec)                                                                                                 
       
            hold on

    line([onsetindexvec';onsetindexvec'],[ones(length(onsetindexvec),1)';ones(length(onsetindexvec),1)'*1400]);

     if length(onsetindexvec) == 64;   
               if blocknum ==1; 
                   convec = hab_codes'; 
               elseif blocknum ==2; 
                    convec = acq_codes'; 
               else
                     convec = ext_codes'; 
               end

       elseif  length(onsetindexvec) == 63;   
          % find where the missing trigger(s) are
         % click where the triggers are missing
          [x,y] = ginput(1)

          % find number of this trigger(s) in onsetvector
          missingindex = max(find(onsetindexvec < x))+1 

                 if blocknum ==1; 
                        hab_codes = hab_codes([1:missingindex-1 missingindex+1:length(hab_codes)]); 
                        convec = hab_codes'; 
                elseif blocknum ==2; 
                        acq_codes = acq_codes([1:missingindex-1 missingindex+1:length(acq_codes)]); 
                        convec = acq_codes'; 
                 else
                        ext_codes = ext_codes([1:missingindex-1 missingindex+1:length(acq_codes)]); 
                        convec = ext_codes'; 
                 end  

        else

            [x,y] = ginput;

           if length(x) + length(onsetindexvec) == 64
                 % find number of these trigger(s) in onsetvector
                         for ind = 1:length(x)
                          missingindexvec(ind) = max(find(onsetindexvec < x(ind)))+ind 
                         end

                        if blocknum ==1; 
                            hab_codes(missingindexvec) = []; 
                            convec = hab_codes'; 
                        elseif blocknum ==2; 
                            acq_codes(missingindexvec) = []; 
                            convec = acq_codes'; 
                        else
                            ext_codes(missingindexvec) = []; 
                            convec = ext_codes'; 
                        end  
            else
               error('click again !!!!') 

           end
            


       end


else % if blocknum == 3, acq block, 8 triggers more

[timevec]=readconfile(copyconfile);%copy of confile,in which the first block(with con nums) is deleted

figure

plot(diff(timevec))

onsetindexvec=find(diff(timevec)<510 & diff(timevec)>500) ;        %find indices of trigs where pics begin - 
                                                                                                        %physiotrig to pic oneset always +500 sp
       length(onsetindexvec)                                                                                                 
       hold on

line([onsetindexvec';onsetindexvec'],[ones(length(onsetindexvec),1)';ones(length(onsetindexvec),1)'*1400]);

if length(onsetindexvec) == 64;   
   if blocknum ==1; 
       convec = hab_codes'; 
   elseif blocknum ==2; 
        convec = acq_codes'; 
   else
         convec = ext_codes'; 
   end
   
elseif  length(onsetindexvec) == 63;   
  % find where the missing trigger(s) are
 % click where the triggers are missing
  [x,y] = ginput(1)
  
  % find number of this trigger(s) in onsetvector
  missingindex = max(find(onsetindexvec < x))+1 
 
         if blocknum ==1; 
                hab_codes = hab_codes([1:missingindex-1 missingindex+1:length(hab_codes)]); 
                convec = hab_codes'; 
        elseif blocknum ==2; 
                acq_codes = acq_codes([1:missingindex-1 missingindex+1:length(acq_codes)]); 
                convec = acq_codes'; 
         else
                ext_codes = ext_codes([1:missingindex-1 missingindex+1:length(acq_codes)]); 
                convec = ext_codes'; 
         end  
    
else
    
    [x,y] = ginput;
    
   if length(x) + length(onsetindexvec) == 64
         % find number of these trigger(s) in onsetvector
                 for ind = 1:length(x)
                  missingindexvec(ind) = max(find(onsetindexvec < x(ind)))+ind 
                 end
         acq_codes( missingindexvec) = [];             
      convec = acq_codes'; 
   else
       error('click again !!!!') 
       
   end
   
        
end


end

%finally, use old confile to construct new
outvec = zeros(length(timevec), 1);
outvec(onsetindexvec+1) = convec; 

