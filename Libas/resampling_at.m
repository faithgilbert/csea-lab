% code for resampling SCADS .at files
% p is the new sampling rate to be resampled to, q is the original sampling
% rate
% Outputs the resampled signal to a .resamp file

function resampling_at(filemat,p,q)

for loop = 1:size(filemat,1)
    
    [AvgMat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,SampRate] = ReadAvgFile(deblank(filemat(loop,:)));
    
    if q ~= SampRate, error('wrong sampling rate...'), end
    
       
        [pathstr, name, ext] = fileparts(deblank(filemat(loop,:)));     % for naming of new file during saveavgfile
        
        AvgMat=AvgMat';
            
            resampled=resample(AvgMat,p,q);           
            
        a_up = resampled';  
        
            
    SaveAvgFile([name '.resamp' ext],a_up,NTrialAvgVec,StdChanTimeMat,p);
end