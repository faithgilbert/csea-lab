%==================================================================%==================================================================clear all;%%	batchSSVEP.m%%	Markus Junghoefer	[1999]\%	mod andreas 2000%%%	Function definition%	%%%%%=================================================================%==================================================================TRStatus=1;[NNetFiles,RAWFileMat]=ReadFileNames([],'*.RAW','Choose NetStation file:');[ch_UseOverAllGainFile]=IfEmptyInputBo('Do you want to use one special gain and one special zero file ?',[],[],1,1);if ch_UseOverAllGainFile	[GainFile,GainPath,GainFilePath]=ReadFilePath([],'*.GAIN','Please choose the over all gain file:');	[ZeroFile,ZeroPath,ZeroFilePath]=ReadFilePath([],'*.ZERO','Please choose the over all zero file:');	if GainFile==0; GainFile=[]; GainPath=[]; GainFilePath=[]; end	if ZeroFile==0; ZeroFile=[]; ZeroPath=[]; ZeroFilePath=[]; endelse	GainFilePath=[];	ZeroFilePath=[];end%===============FilterNetFile====================================%%Filter 50 Hz LowPassch_LowPassFilt=1;ch_HighPassFilt=0;SampRate=[];if ch_LowPassFilt | ch_HighPassFilt	for FileInd=1:NNetFiles		[NoUse,NoUse,NetFilePath]=GetFileNameOfMat(RAWFileMat,FileInd);		[NoUse,NoUse,NoUse,NoUse, ...		NoUse, NoUse, NoUse, NoUse, NoUse, NoUse, NoUse, ...		SampRateTmp,NChan]= ReadRAWHeader(NetFilePath);		if ~isempty(SampRate)			 if SampRateTmp~=SampRate				error('It is not possible to filter in batch mode because of different samp rates in different files !')			end		end		SampRate=SampRateTmp;	endendHighDefFreqsMat=[SampRate 3 0];HighDefRipMat=[3 45];LowDefFreqsMat=[SampRate 40 50]; LowDefRipMat=[3 45];ch_ChooseChannelInd=0;ChanStatusVec=ones(NChan,1);PlotStatus=0;ch_AddSubZeros=0;NZPoints=[];[ch_LowPassFilt,LowB,LowA,ch_HighPassFilt,HighB,HighA,LowFreqsMat,HighFreqsMat] = ...GetHighLowFiltCoeff(SampRate,HighDefFreqsMat,HighDefRipMat,LowDefFreqsMat,LowDefRipMat,...ch_LowPassFilt,ch_HighPassFilt);%=============================================================%===============Transform data file format=======================[TAWFileMat,TRStatus]=TransRawTaw(RAWFileMat,TRStatus,10);% %===============FilterNetFile====================================[FilterTAWFileMat]=FilterNetFile(TAWFileMat,ch_LowPassFilt,LowB,LowA,...ch_HighPassFilt,HighB,HighA,LowFreqsMat,HighFreqsMat,...ch_ChooseChannelInd,ChanStatusVec,PlotStatus,ch_AddSubZeros,NZPoints,TRStatus);%=============================================================%DeleteFileMat(TAWFileMat);%===============TransNetGeoHistNew====================================%[EGISFileMat,NetFileMat]=TransNetGeoHistNew(NetFileMat,TRStatus,...%PreTrig,PostTrig,ReTrig,GainFilePath,ZeroFilePath,OldZeroVersion,NGainZeroString,SpecCondVec)OldZeroVersion=0;NInt=3;PreTrigInt=700;PostTrigInt=500;%[EGISFileMat,NetFileMat]=TransNetGeoHistNew(NetFileMat,TRStatus,...% PreTrig,PostTrig,ReTrig,GainFilePath,ZeroFilePath,OldZeroVersion,NGainZeroString,SpecCondVec)[FilterEGISFileMat]=TransNetGeoHist_15(FilterTAWFileMat,TRStatus,PreTrigInt,PostTrigInt,1,GainFilePath,ZeroFilePath,OldZeroVersion)%=============================================================%DeleteFileMat(FilterTAWFileMat);%===============CalcAutoEditMat ohne avg ref EEG und ohne flat====================================%[AEMFilePathMat]=CalcAutoEditMat(FileMat,TimeStatusVec,ch_CalcAvgRef,ch_UseSpecChan,...%ch_CalcBaseline,BaseStartPoint,BaseEndPoint,ch_ChooseTimeInd,LFlatWin,ch_CalcFlaMat,ch_UseAWE);[AEMFilePathMat]=CalcAutoEditMat(FilterEGISFileMat,ones(1,PostTrigInt+PreTrigInt+1),0,[],1,1,PreTrigInt,1,10,0,0);%======Such nach schlechten Kanaelen ==================================%FindBadChan(AEMFilePathMat,AWELimesFac,BatchStatus);FindBadChan(AEMFilePathMat,3,1);%======Such nach schlechten trials ==================================% [AWEFileMat]=FindBadChanTrial(FilePathMat,AWELimesFac,BatchStatus);FindBadChanTrial(AEMFilePathMat,2.5,1); %===============CalcAutoEditMat mit avg ref EEG und mit flat====================================%[AEMFilePathMat]=CalcAutoEditMat(FileMat,TimeStatusVec,ch_CalcAvgRef,ch_UseSpecChan,...%ch_CalcBaseline,BaseStartPoint,BaseEndPoint,ch_ChooseTimeInd,LFlatWin,ch_CalcFlaMat,ch_UseAWE);[AEMFilePathMat]=CalcAutoEditMat(FilterEGISFileMat,ones(1,PostTrigInt+PreTrigInt+1),1,1,1,1,PreTrigInt,0,8,1,1);