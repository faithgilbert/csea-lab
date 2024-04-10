% bslcorrWAMat% subtracts the 2dimensional time-frequency matrix selected by the user% from all submatrices(timepints) of 3dim WAmatrixfunction[outWaMat] = bslcorrWAMat(inMat, timevec)if nargin < 2   timevec = input('give indices of the timevector to be used as baseline');endif nargin < 1   [File, Path] = uigetfile('*');   disp([Path File])   eval(['load ' Path File]);   inMat = AvgWaPower;endbslMat = (mean(inMat(:, timevec, :), 2));outWaMat = inMat - repmat(bslMat, [1,size(inMat,2),1]);