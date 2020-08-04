% topottest% determines t-values for topographies % filemat1 and filemat2 are matrices of filenames for participants in a% given condition, created by getfilesindir% -bslvec os vactor of sample points to be subtracted. can be empty [ ] function [topo_tmat, mat3d_1, mat3d_2] = topottest_log(filemat1, filemat2, bslvec, outname)if nargin < 4;     outname = []; end[a,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,...	SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec,EegMegStatus,...    NChanExtra,TrigPoint,HybridFactor,HybridDataCell,DataTypeVal]=ReadAvgFile(deblank(filemat1(1,:))); mat3d_1 = zeros(size(a,1), size(a,2), size(filemat1,1) ); mat3d_2 = zeros(size(a,1), size(a,2), size(filemat1,1) ); for subject = 1:size(filemat1,1);        a = readavgfile(deblank(filemat1(subject,:)));        if ~isempty (bslvec)    mat3d_1(:,:, subject) = bslcorr(a, bslvec);    else       mat3d_1(:,:, subject) = a;    end              b = readavgfile(deblank(filemat2(subject,:)));           if ~isempty (bslvec)        mat3d_2(:,:, subject) = bslcorr(b, bslvec);       else          mat3d_2(:,:, subject) = b;       endendmat3d_2 = log(mat3d_2+2); mat3d_1 = log(mat3d_1+2); [dummy, dummy, dummy, stats] = ttest(mat3d_2, mat3d_1, 0.05, [], 3); topo_tmat = stats.tstat; if isempty(outname); SaveAvgFile('Ttest.at.ar',topo_tmat,NTrialAvgVec,StdChanTimeMat, ...    SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus,NChanExtra,TrigPoint,HybridFactor); else    SaveAvgFile(outname, topo_tmat,NTrialAvgVec,StdChanTimeMat, ...    SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus,NChanExtra,TrigPoint,HybridFactor); end        