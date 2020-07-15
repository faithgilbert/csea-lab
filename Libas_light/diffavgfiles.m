function [] = diffavgfiles(inmat1, inmat2, outname, logflag); 

for index = 1:size(inmat1,1); 
    
     [AvgMat1,File,Path,FilePath,NTrialAvgVec,StdMat,SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec,...
     EegMegStatus,NChanExtra,TrigPoint,HybridFactor,HybridDataCell,DataTypeVal]=ReadAvgFile(deblank(inmat1(index,:)));
 
    [AvgMat2,File,Path,FilePath,NTrialAvgVec,StdMat,SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec,...
     EegMegStatus,NChanExtra,TrigPoint,HybridFactor,HybridDataCell,DataTypeVal]=ReadAvgFile(deblank(inmat2(index,:)));

 if logflag
    diffmat = log(AvgMat1)-log(AvgMat2); 
 else
     diffmat = (AvgMat1)-(AvgMat2); 
 end
    
    SaveAvgFile([outname '.at' num2str(index)],diffmat,NTrialAvgVec,StdMat,SampRate,MedMedRawVec,MedMedAvgVec,...
EegMegStatus,NChanExtra,TrigPoint,HybridFactor,HybridDataCell,DataTypeVal);

end