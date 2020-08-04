% liest operantfiles aus und erstellt lernkurvenfiles%% function deffunction[RTvecOKmavg, RTvecKmavg, RewardvecOK, RewardvecK] = getacquiscurve(FilePath);if nargin == 0	[File, Path]=uigetfile ('ubies:exoperant:behav:*txt', 'select DOS txt file');	FilePath = [Path File];end% txt file oeffnen[fid, msg] = fopen(FilePath, 'r' );if fid == -1  error(msg);end;% header lesen und anzeigendumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);% EP-Block%% EP-Block einlesen und anzeigenstimvecEP = [ ];for EPtrial = 1 : 60;	lineEP = fgetl(fid);	stimvecEP(EPtrial,:) = str2num(lineEP); end% EP-conditionfile erzeugenEPcon = [ ];for index = 1 : 60;	if stimvecEP(index,2) >= 30		EPcon(index) = 1;	else		EPcon(index) = 0;	endendEPcon = EPcon';% naechsten block file einlesen:  OK (SP vorher oder nachher)dumline = fgetl(fid)if dumline == ['SP Durchgang']	dumline = fgetl(fid);	dumline = fgetl(fid);	dumline = fgetl(fid);	dumline = fgetl(fid);endHitmatOK = [ ];for trial = 1 : 60;	lineOK = fgetl(fid);	if length(str2num(lineOK)) > 5	HitmatOK(trial,:) = [0 1 10 0 10];	else	HitmatOK(trial,:) = str2num(lineOK);	end end dumline = fgetl(fid); for trial = 61 : 120;	lineOK = fgetl(fid);	linevecOK =  str2num(lineOK);		if length(linevecOK) > 5 & linevecOK(6)>0	      HitmatOK(trial,:) = [0 1 10 0 10];	elseif length(linevecOK) > 5 & linevecOK(6)==0	      HitmatOK(trial,:) = [0 0 0 0 0];	else        HitmatOK(trial,:) = str2num(lineOK);	end enddumline = fgetl (fid);if dumline == ['SP Durchgang']	dumline = fgetl(fid)	dumline = fgetl(fid)	dumline = fgetl(fid)	dumline = fgetl(fid)end% K durchgang einlesenHitmatK = [ ]for index = 1 : 90	lineK = fgetl(fid);	linevec = str2num(lineK);	if length(linevec) == 4	HitmatK(index,:) = [(linevec) linevec(4)];	else	HitmatK(index,:) = (linevec);	end end dumline = fgetl (fid); for index = 91 : 180	lineK = fgetl(fid);	linevec = str2num(lineK);	if length(linevec) == 4	HitmatK(index,:) = [(linevec) linevec(4)];	else	HitmatK(index,:) = (linevec);	end end % relevante matrizen: % HitmatK und HitmatOK: einzelne Vektoren glaetten (moving average) und abspeichern  % 1. HitmatOK % for index = 1 : length(HitmatOK) - 8;	 RTvecOKmavg = (HitmatOK(:, 3));	 RewardvecOK = (HitmatOK(:,5));% endLimholdvecOK = HitmatOK(:,4); % 2.HitmatK %for index = 1 : length(HitmatK) - 8;	 RTvecKmavg = HitmatK(:, 4);	  RewardvecK = (HitmatK(:,5));% endfclose(fid)fnameRT_OK = ([ FilePath(23:26) 'OK_RT']);fnameRT_K = ([FilePath(23:26) 'K_RT']);fnameRwd_OK = ([ FilePath(23:26) 'OK_Rwd']);fnameRwd_K = ([ FilePath(23:26) 'K_Rwd']);fnameLH_OK = ([FilePath(23:26) 'OK_LH']);%eval(['save ubies:exoperant:behav:acquisition:' fnameRT_OK ' RTvecOKmavg -ascii']);%eval(['save ubies:exoperant:behav:acquisition:' fnameRT_K ' RTvecKmavg -ascii']);%eval(['save ubies:exoperant:behav:acquisition:' fnameRwd_OK ' RewardvecOK -ascii']);%eval(['save ubies:exoperant:behav:acquisition:' fnameRwd_K ' RewardvecK -ascii']);%eval(['save ubies:exoperant:behav:acquisition:' fnameLH_OK ' LimholdvecOK -ascii']);