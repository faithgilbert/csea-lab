% hilbert transform and display/saving of envelope function[]=ascii2scads(filemat, SampRate);for index = 1:size(filemat,1);         if ~isstruct(filemat);         atgPath = deblank(filemat(index,:));    else        atgPath = filemat(index).name;     end	   a = load(atgPath);       outmat = a;		[File,Path,FilePath]=SaveAvgFile([atgPath '.atg.ar' ],outmat,[],[], SampRate);   % [File,Path,FilePath]=SaveAvgFile([atgPath '.hphas'],phasemat,NTrialAvgVec,StdChanTimeMat, SampRate);    %eval(['save ' deblank(atgPath) '.pha phasemat -ascii'])end