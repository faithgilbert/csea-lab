% mn_irina% andreas 2000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [filemat] = mn_irina(filemat);if nargin < 1	filemat = readfilenames; end%disp('note: only one regpar available at this time ')% File an irina: elek.datload Alix:MATLAB:Plot2d3d:Plot3dInvCoeff:elek.datelek = elek';LFDim = 3;EEGMEGStatusString = 'EEG'ShellNo = 1CortRadius = 0.0815; 		%radius of shell 1 (brain or cort)CsfRadius=0.0836;			%radius of shell 2 (cerebro-spinal fluid)SkullRadius=0.0878; 		%radius of shell 3 (skull)ScalpRadius=0.092; 			LeadLocCfg='655';NLeadLoc=655;NLeadLocVec=[350 197 87 21];LeadLocIntMat=[1 350;351 547;548 634;635 655];	NLeadLoc=NLeadLocVec(ShellNo);LeadLocInt=LeadLocIntMat(ShellNo,:);			LFCoeffFile = ['Alix:MATLAB:Plot2d3d:Plot3dInvCoeff:LFE_655_129'];				LeadLocFile=['Alix:MATLAB:Plot2d3d:Plot3dInvCoeff:DLoc_655_Cart'];LeadLoc=ReadData(LeadLocFile,1);LeadRadius=sqrt(sum(LeadLoc(LeadLocInt(1),1:3).^2));LeadLocShell=LeadLoc(LeadLocInt(1):LeadLocInt(2),1:3);LeadLocTmp=LeadLocShell.*ScalpRadius./LeadRadius;				PILFCoeffFile=['Alix:MATLAB:Plot2d3d:Plot3dInvCoeff:PILFE_655_129_200'];%	PILFE if EEG; PILFM if MEGPILFCoeffFid=exist(PILFCoeffFile);				if PILFCoeffFid==0				LFCoeffFile = [PathLFCoeff,FILESEP,'LF' EEGMEGStatusString(1) '_' LeadLocCfg '_' ECfg];			%LFE if EEG; LFM if MEG			LFCoeffFid=exist(LFCoeffFile);			if LFCoeffFid==0				Message=char(['Calculate ' EEGMEGStatusString ' leadfield coefficients']);				Message=char(Message,'and save them to file:');							Message=char(Message,LFCoeffFile);				Message=char(Message,' ');				Message=char(Message,'This calculation could take ');				Message=char(Message,'between one and three minutes. ');				Message=char(Message,' ');				Message=char(Message,'Open the Matlab Command window');				Message=char(Message,'to follow up the progress of calculation.');				Message=char(Message,' ');				hmsgbox=msgbox(Message,'Info:','help');				hChildMsgbox=get(hmsgbox,'Children');				set(hChildMsgbox(3),'Visible','off');       		  		pause(.01);				[LFCoeff, Orientations, v] = compute_lfdmat(LeadLoc(:,1:3)',SensorMat',EEGMEGStatusString,'sph');				if strcmp(EEGMEGStatusString,'MEG')					LFCoeff=LFCoeff./0.0003145;				elseif strcmp(EEGMEGStatusString,'EEG')					LFCoeff=LFCoeff./50;				end				SaveData(LFCoeff,LFCoeffFile,1);			else				Message=char(['Read ' EEGMEGStatusString ' leadfield coefficients from file:']);				Message=char(Message,LFCoeffFile);				Message=char(Message,' ');				hmsgbox=msgbox(Message,'Info:','help'); 				hChildMsgbox=get(hmsgbox,'Children');				set(hChildMsgbox(3),'Visible','off');				pause(.01);				LFCoeff=ReadData(LFCoeffFile,1);			end			Message=char(['Calculate ' EEGMEGStatusString ' pseudo inverse leadfield coefficients']);			Message=char(Message,'and save them to file:');			Message=char(Message,PILFCoeffFile);			hChildMsgbox=get(hmsgbox,'Children');			set(hChildMsgbox(2),'String',Message);			set(hChildMsgbox(3),'Visible','off');												PILFCoeff=pinv_tikh(LFCoeff,MNLambdaApprox);			SaveData(PILFCoeff,PILFCoeffFile,1);			set(hPlot3dList(97),'Userdata',PILFCoeff);			close(hmsgbox);		else				Message=char(['Read ' EEGMEGStatusString ' pseudo inverse leadfield coefficients from file:']);			Message=char(Message,PILFCoeffFile);						PILFCoeff=ReadData(PILFCoeffFile,1);								end		for FileIndex = 1:size(filemat, 1);		disp('read data')		[data,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec] = readavgfile(filemat(FileIndex, :));		%bslcorrektur		disp('baseline correction')		for chan = 1: 129			data(chan, :) = data(chan, :) - mean(data(chan,bslvec));		end														MNMat=inv_recon(PILFCoeff((LeadLocInt(1)-1).*3+1:LeadLocInt(2).*3,:),data,3);		[NMNMat,NoUse]=size(MNMat);						%=====Calculate spline interpolation==========		c0M=mean(MNMat);			C0MNMat=MNMat-(c0M'*ones(1,NMNMat))';			      	if NLeadLoc>100			InvIter=15;			ForIter=15;		elseif NLeadLoc<100 & NLeadLoc>60			InvIter=12;			ForIter=12;		else			InvIter=9;			ForIter=9;		end				XYZMat=inv_recon(PILFCoeff((LeadLocInt(1)-1).*LFDim+1:LeadLocInt(2).*LFDim,:),data,1);		%clear PILFCoeff      	XMat=XYZMat([1:3:3.*NLeadLoc-2],:);	c0X=mean(XMat); C0XMat=XMat-(c0X'*ones(1,NMNMat))';     	YMat=XYZMat([2:3:3.*NLeadLoc-1],:);	c0Y=mean(YMat); C0YMat=YMat-(c0Y'*ones(1,NMNMat))';    	ZMat=XYZMat([3:3:3.*NLeadLoc],:);	c0Z=mean(ZMat); C0ZMat=ZMat-(c0Z'*ones(1,NMNMat))';			% look for dipoles that are closest to sensor sitesfor elcNo = 1 : 129		diffvecX = elek(elcNo,1) - LeadLocShell(:,1);	diffvecY = elek(elcNo,2) - LeadLocShell(:,2);	diffvecZ = elek(elcNo,3) - LeadLocShell(:,3);		diffvecabs = sqrt(diffvecX.^2 + diffvecY.^2 + diffvecZ.^2);		lfdindexvec(elcNo) = find(diffvecabs == min(diffvecabs));	end		absmat = MNMat(lfdindexvec,:);	SaveAvgFile([filemat(FileIndex,:) 'MN'],absmat,NTrialAvgVec,StdChanTimeMat,SampRate,MedMedRawVec,MedMedAvgVec)end																		