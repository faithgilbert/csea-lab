%get_log_abip_impl.m   function [T2_hitrate, T2_RT, resptime_trial_vec, T2_trial_Resp_vec] = get_log_abip_impl(infilepath);% tastencode 1 = ALTGR = wort% tastencode 2 = ALTGR = pseudowortfid = fopen(infilepath)% dummylinesdumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);dumline = fgetl(fid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  fuer altgr == wortline = 1;index = 1;			while line > 0				% read data				line = fgets(fid);				if isempty(str2num(line(1))), disp(['events found: ']), disp(eventnum), disp(['lines found: ']), disp(index-1), break, end		if line < 0, break, return, end				% segmentiere jede zeile nach tabs				trialnumseg = find(line == '	');				% event-tags				eventnum = str2num(line(1:trialnumseg(1)-1));				eventkind = line(trialnumseg(1)+1:trialnumseg(2)-1);				eventcateg = line(trialnumseg(2)+1:trialnumseg(3)-1);				%eventtimeold = str2num(line(trialnumseg(3)+1:trialnumseg(4)-1));                eventtime(index) = str2num(line(trialnumseg(4)+1:trialnumseg(5)-1));                				% denksport		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%			% 1. suche nach allen trialendenden:  picture time followed by		% response				if strcmp(eventcateg, 'time'), trialend_vec(index) = 2 ;		else trialend_vec(index) = 0;		end				if index == 1, trialend_vec(index) = 0; end														% abfragen fuer T1		if strcmp('T1_pleasant', eventcateg), T1_dummy(index) = 1;		elseif strcmp('T1_neutral', eventcateg), T1_dummy(index) = 2;		elseif strcmp('T1_unpleasant', eventcateg), T1_dummy(index) = 3;		elseif strcmp('T1_DD', eventcateg), T1_dummy(index) = 4;		%elseif strcmp('T1_5', eventcateg), T1_dummy(index) = 5;		else T1_dummy(index) = 0;		end				% abfragen fuer SOA		if strcmp('SOA1', eventcateg), SOA_dummy(index) = 1;		elseif strcmp('SOA2', eventcateg), SOA_dummy(index) = 2;		elseif strcmp('SOA3', eventcateg), SOA_dummy(index) = 3;		else SOA_dummy(index) = 0;		end			% abfragen fuer T2s		if strcmp('T2_1', eventcateg), T2_dummy(index) = 1;		elseif strcmp('T2_2', eventcateg), T2_dummy(index) = 2;		elseif strcmp('T2_3', eventcateg), T2_dummy(index) = 3;        elseif strcmp('T2_4', eventcateg), T2_dummy(index) = 4;        elseif strcmp('T2_5', eventcateg), T2_dummy(index) = 5;		else T2_dummy(index) = 0;		end					% abfragen fuer mausklicks und buttons		if strcmp('0', eventcateg), response_dummy(index) = 0;		elseif strcmp('1', eventcateg), response_dummy(index) = 1;	    elseif strcmp('2', eventcateg), response_dummy(index) = 2;		elseif strcmp('3', eventcateg), response_dummy(index) = 3;		elseif strcmp('4', eventcateg), response_dummy(index) = 4;		elseif strcmp('5', eventcateg), response_dummy(index) = 5;		else  response_dummy(index) = -1;		end            % abfragen fuer time         if response_dummy(index) > -1;            time_dummy(index) = eventtime(index);        else time_dummy(index) = -1;         end		index = index + 1;			% for correctflag	end	%eventtime = eventtime  ./ 10; % in millisekunden (statt mikrosec)	% 'offline denksport'	trialend_indices_vec = find(trialend_vec == 2);		disp('anzahl trialenden: ')	disp(length(trialend_indices_vec))		% gehe durch die trials und berechne das interessierende				for trialnum = 1 : length(trialend_indices_vec);								if trialnum == 1									  for eventindex = 1:trialend_indices_vec(1)+1;					   					  % finde T1 art					  if T1_dummy(eventindex)>0, T1_trial_vec(trialnum) = T1_dummy(eventindex); end					  					  % finde SOA art					  if SOA_dummy(eventindex)>0, SOA_trial_vec(trialnum) = SOA_dummy(eventindex); end					  					  % finde T2 valenz					   if T2_dummy(eventindex)>0, T2_trial_vec(trialnum) = T2_dummy(eventindex);end					   					  % finde response auf T2								    					   if eventindex == trialend_indices_vec(1)+1, T2_trial_Resp_vec(trialnum) = response_dummy(eventindex);end													  % finde response time                                              if eventindex == trialend_indices_vec(1), stimtime = time_dummy(eventindex);end                        if eventindex == trialend_indices_vec(1)+1, resptime_trial_vec(trialnum) = time_dummy(eventindex) - stimtime; end                                                                end							        else							for eventindex = trialend_indices_vec(trialnum-1):trialend_indices_vec(trialnum)+1;											% finde T1 art					  if T1_dummy(eventindex)>0, T1_trial_vec(trialnum) = T1_dummy(eventindex); end					  					  % finde SOA art					  if SOA_dummy(eventindex)>0, SOA_trial_vec(trialnum) = SOA_dummy(eventindex); end					  					  % finde T2 valenz					   if T2_dummy(eventindex)>0, T2_trial_vec(trialnum) = T2_dummy(eventindex);end					   					  % finde response auf T2								    					   if eventindex == trialend_indices_vec(trialnum)+1, T2_trial_Resp_vec(trialnum) = response_dummy(eventindex);end				                           % finde response time                                              if eventindex == trialend_indices_vec(trialnum), stimtime = time_dummy(eventindex);end                        if eventindex == trialend_indices_vec(trialnum)+1, resptime_trial_vec(trialnum) = time_dummy(eventindex) - stimtime; end				  end				end	        end	% statmat = [condition_vec' correctvec' RTvec'];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% aus den trialvektoren statistikinfo berechnen:% indizesSOA1_indices = find(SOA_trial_vec == 1);SOA2_indices = find(SOA_trial_vec == 2);SOA3_indices = find(SOA_trial_vec == 3);T1_pleas_indices = find(T1_trial_vec == 1);T1_neutr_indices = find(T1_trial_vec == 2);T1_unplea_indices = find(T1_trial_vec == 3);T1_DD_indices = find(T1_trial_vec == 4);ple_lag1_indices = find(T1_trial_vec == 1 & SOA_trial_vec ==1);ntr_lag1_indices = find(T1_trial_vec == 2 & SOA_trial_vec ==1);upl_lag1_indices = find(T1_trial_vec == 3 & SOA_trial_vec ==1);DD_lag1_indices = find(T1_trial_vec == 4 & SOA_trial_vec ==1);ple_lag2_indices = find(T1_trial_vec == 1 & SOA_trial_vec ==2);ntr_lag2_indices = find(T1_trial_vec == 2 & SOA_trial_vec ==2);upl_lag2_indices = find(T1_trial_vec == 3 & SOA_trial_vec ==2);DD_lag2_indices = find(T1_trial_vec == 4 & SOA_trial_vec ==2);ple_lag3_indices = find(T1_trial_vec == 1 & SOA_trial_vec ==3);ntr_lag3_indices = find(T1_trial_vec == 2 & SOA_trial_vec ==3);upl_lag3_indices = find(T1_trial_vec == 3 & SOA_trial_vec ==3);DD_lag3_indices = find(T1_trial_vec == 4 & SOA_trial_vec ==3);%%%%%%%%%%%%%%%%%%%% todo: T2 masse fuer korrekte T1 !!!!!!!!!!!!!!!!!!!!!!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%T2_hits_ple_SOA1_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 1 & T1_trial_vec == 1 & resptime_trial_vec > 150);T2_hits_ntr_SOA1_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 1 & T1_trial_vec == 2 & resptime_trial_vec > 150);T2_hits_upl_SOA1_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 1 & T1_trial_vec == 3 & resptime_trial_vec > 150);T2_hits_DD_SOA1_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 1 & T1_trial_vec == 4 & resptime_trial_vec > 150);T2_hits_ple_SOA2_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 2 & T1_trial_vec == 1 & resptime_trial_vec > 150);T2_hits_ntr_SOA2_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 2 & T1_trial_vec == 2 & resptime_trial_vec > 150);T2_hits_upl_SOA2_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 2 & T1_trial_vec == 3 & resptime_trial_vec > 150);T2_hits_DD_SOA2_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 2 & T1_trial_vec == 4 & resptime_trial_vec > 150);T2_hits_ple_SOA3_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 3 & T1_trial_vec == 1 & resptime_trial_vec > 150);T2_hits_ntr_SOA3_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 3 & T1_trial_vec == 2 & resptime_trial_vec > 150);T2_hits_upl_SOA3_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 3 & T1_trial_vec == 3 & resptime_trial_vec > 150);T2_hits_DD_SOA3_indices = find(T2_trial_Resp_vec == T2_trial_vec & SOA_trial_vec == 3 & T1_trial_vec == 4 & resptime_trial_vec > 150);% T2 hits for Rts > 150  hier obige length(index einfuegen) T2hitrate_ple_lag1 =  (length(T2_hits_ple_SOA1_indices) ./ length(ple_lag1_indices)) .*100; T2hitrate_ntr_lag1 =  (length(T2_hits_ntr_SOA1_indices) ./ length(ntr_lag1_indices)) .*100; T2hitrate_upl_lag1 =  (length(T2_hits_upl_SOA1_indices) ./ length(upl_lag1_indices)) .*100; T2hitrate_DD_lag1 =  (length(T2_hits_DD_SOA1_indices) ./ length(DD_lag1_indices)) .*100;  T2hitrate_ple_lag2 =  (length(T2_hits_ple_SOA2_indices) ./ length(ple_lag2_indices)) .*100; T2hitrate_ntr_lag2 =  (length(T2_hits_ntr_SOA2_indices) ./ length(ntr_lag2_indices)) .*100; T2hitrate_upl_lag2 =  (length(T2_hits_upl_SOA2_indices) ./ length(upl_lag2_indices)) .*100; T2hitrate_DD_lag2 =  (length(T2_hits_DD_SOA2_indices) ./ length(DD_lag2_indices)) .*100;  T2hitrate_ple_lag3 =  (length(T2_hits_ple_SOA3_indices) ./ length(ple_lag3_indices)) .*100; T2hitrate_ntr_lag3 =  (length(T2_hits_ntr_SOA3_indices) ./ length(ntr_lag3_indices)) .*100; T2hitrate_upl_lag3 =  (length(T2_hits_upl_SOA3_indices) ./ length(upl_lag3_indices)) .*100; T2hitrate_DD_lag3 =  (length(T2_hits_DD_SOA3_indices) ./ length(DD_lag3_indices)) .*100; %  T2_hitrate = [T2hitrate_ple_lag1 T2hitrate_ntr_lag1 T2hitrate_upl_lag1 T2hitrate_DD_lag1 T2hitrate_ple_lag2 T2hitrate_ntr_lag2 T2hitrate_upl_lag2 T2hitrate_DD_lag2 T2hitrate_ple_lag3 T2hitrate_ntr_lag3 T2hitrate_upl_lag3 T2hitrate_DD_lag3] %%%%%%%%%%%%%%%%%%%%%%%%%% RESPONSE TIME %%%%%%%%%%%%%%%%%%%%%%%%% T2_RT_ple_lag1 = median(resptime_trial_vec(T2_hits_ple_SOA1_indices));T2_RT_ntr_lag1 = median(resptime_trial_vec(T2_hits_ntr_SOA1_indices));T2_RT_upl_lag1 = median(resptime_trial_vec(T2_hits_upl_SOA1_indices));T2_RT_DD_lag1 = median(resptime_trial_vec(T2_hits_DD_SOA1_indices));T2_RT_ple_lag2 = median(resptime_trial_vec(T2_hits_ple_SOA2_indices));T2_RT_ntr_lag2 = median(resptime_trial_vec(T2_hits_ntr_SOA2_indices));T2_RT_upl_lag2 = median(resptime_trial_vec(T2_hits_upl_SOA2_indices));T2_RT_DD_lag2 = median(resptime_trial_vec(T2_hits_DD_SOA2_indices));T2_RT_ple_lag3 = median(resptime_trial_vec(T2_hits_ple_SOA3_indices));T2_RT_ntr_lag3 = median(resptime_trial_vec(T2_hits_ntr_SOA3_indices));T2_RT_upl_lag3 = median(resptime_trial_vec(T2_hits_upl_SOA3_indices));T2_RT_DD_lag3 = median(resptime_trial_vec(T2_hits_DD_SOA3_indices));T2_RT = [T2_RT_ple_lag1 T2_RT_ntr_lag1 T2_RT_upl_lag1 T2_RT_DD_lag1 T2_RT_ple_lag2 T2_RT_ntr_lag2 T2_RT_upl_lag2 T2_RT_DD_lag2 T2_RT_ple_lag3 T2_RT_ntr_lag3 T2_RT_upl_lag3 T2_RT_DD_lag3] % eval(['save ' infilepath '.T1_stat T1_stat -ascii'])% % eval(['save ' infilepath '.T2_RT T2_RT -ascii'])%  eval(['save ' infilepath '.T2_hits T2_hitrate -ascii'])% fclose('all')