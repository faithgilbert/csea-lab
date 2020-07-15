function[]=mat2scadsNOAM(matfilemat, confilemat, SampRate);% reads EEG.data array previously stored to disk as a mat file with 3-d% elcs time trials, averages for conditions it finds in text file with% condition information (6 conditions) and saves as atg filesfor index = 1:size(matfilemat,1);         confilepath = deblank(confilemat(index,:));         if ~isstruct(matfilemat);         atgPath = deblank(matfilemat(index,:));    else        atgPath = matfilemat(index).name;     end	  a = load(atgPath);   EEGdata3d = a.datamat;  conditions = load(confilepath);      % average by condition     for x = 1:3       avgmat = mean(EEGdata3d(:,:,find(conditions==x)),3);		[File,Path,FilePath]=SaveAvgFile([atgPath '.at' num2str(x) '.ar' ],avgmat,[],[], SampRate);   % [File,Path,FilePath]=SaveAvgFile([atgPath '.hphas'],phasemat,NTrialAvgVec,StdChanTimeMat, SampRate);    %eval(['save ' deblank(atgPath) '.pha phasemat -ascii'])   end   end