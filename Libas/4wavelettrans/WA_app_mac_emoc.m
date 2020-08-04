function[testmat]  = WA_app_mac_emoc(directory)% function[]  = WA_app()%% Nur fuer insider%  % f0_start und f_end entsprechen NICHT Frequenzen sondern% Datenpunkten, d.h. wenn die Epoche z.B. 2048 Punkte lang ist% (nach dem Zeropadding) und eine Samplingrate von 500 Hz verwendet wurde% ergibt sich eine Frequenzaufloesung von fa = 500/2048 = 0.244.% fa * fO_start ergibt die tatsaechliche Startfrequenz% fa * f0_end ergibt die tatsaechliche Endfrequenz% Die Wavelets werden nicht fuer jeden Punkt sondern fuer jeden% delta_f0ten Punkt berechnet, um Speicher zu sparen%% Ergibt sich also z.B. ein Wavelet mit 49 Zeilen, f0_start bei 10% und F0_end von 250 und delta_f0 von 5 und 500 Hz ergibt sich:%% 500/2048 = 0.244;% 10 * 0.244  = 2.44 Hz Startfrequenz% 250 * 0.244 = 61 Hz Endfrequenz% 2.44 : 5*0.244 : 61 = 49 Zeilen im Wavelet%% Paramenter sind im Sourcecode einzutragen%% Das Programm erzeut 2 files (Endungen WA und RA)% in denen die spektrale Power (WA) und der Phaselockingfaktor (RA)% abgespeichert werden (vgl Tallon et al, 1997)% (die Matrix RA kann mit der Pruefgroesse R auf Signifikanz%  ueberpruft werden (vgl. Dissertation Wienbruch, Kapitel 2, Formel 51)%% infant data: frq resolution: 0.3906% faxis = 0:0.3906:70;% %% (c) Keil & Gruber, 1999%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EPsubFlag = 0resize_flag = 1     % 1 : Resizefunktion an (siehe Zeile 111)						  % 0 : Resizefunktion aus	                    % ueberfluessige Werte durch Zeropadding fliegen raus und nur jeder                     % <resize_step> .te Wert wird gespeichertresize_step = 1     % Schrittweite der Resizefunktion						  % (1 : jeder Wert wird geschrieben)                    % ACHTUNG: dies muss natuerlich bei der Achsenbeschriftung                    % mit make_xy_wa beruecksichtigt werden                    Phase_lock_flag = 1 % 1 : Phaselockfaktor Datei wird erzeugt						  % 0 : Phaselockfaktor Datei wird nicht erzeugt						  						  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   code:						  files = [];testmat = []; [files, namelist, dirname] = getfilesindir(directory);FilePath = dirnamedisp('electrodes to analyze');electrodes = [1:129];   %Electrodes to analyzedelta_f0 = 1f0_start = 8f0_end = 90%Schleife ueber filesfor nf = 1 : size(files,1)  file_name = [FilePath ':' namelist(nf,:)]  [data,Version,LHeader,ScaleBins,NChan,NPointsold,NTrials,SampRate,ch_AvgRef]=ReadAppData(file_name);  disp('size of data matrix')  disp(size(data))  % Npoints runden auf naechste 2erpotenz  matsize = 2;  potsize = 2;  while matsize < NPointsold;  potsize = potsize + 1;  matsize = 2^potsize;  end  NPointsNew = matsize;  wavelet = gener_Wav(NPointsNew, delta_f0, f0_start, f0_end);  disp('size of waveletMatrix')  disp(size(wavelet))  disp (' frequency step for delta_f0 = 1 is ')  disp(SampRate/NPointsNew)      % Berechnung der WA  SumPower = [];  AvgWaPower = [];      %schleife ueber KANAELE  for e  = 1 :  size(electrodes,2);     channel = electrodes(e);      % schleife ueber TRIALS	  for trial = 1 : NTrials;         %fprintf('wa of channel %g , trial %g of %g   ',channel, trial, NTrials)		 [data]=ReadAppData(file_name, trial, channel);		% plot(data'), pause		 % daten padden bis N = NPoints = 2^X       % dazu: daten auf jeden fall als ZEILENVEKTOR !!!!            			a = size(data);               if a (1) ~= 1                  data = data';               end                      data_pad = [data'; zeros(NPointsNew-NPointsold,1)];                     [WAPower, WARayleigh]=wa_new(data_pad, wavelet, NPointsNew, delta_f0, f0_start, f0_end,NPointsold);	  	   testmat(e,trial) = max(max(WAPower));		                     if trial == 1		 SumPower = WAPower;       SumRayleigh = WARayleigh;       else        SumPower = SumPower + WAPower;       SumRayleigh = SumRayleigh+WARayleigh;         	 end           end     fprintf('writing channel # %g to Average Matrix', e)          if resize_flag == 1 		        % !!!!!!!!!!!!!!!! RESIZE FUNKTION !!!!!!!!!!!!!!!!!!!       % damit die matrix nicht zu gross wird       % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	          disp('resizing matrix')       SumPower = SumPower(:, [1:resize_step:NPointsold]);       SumRayleigh = SumRayleigh(:, [1:resize_step:NPointsold]);     end;          AvgWaPower(e,:,:) = SumPower./NTrials;     PhasLockfac(e,:,:) = abs(SumRayleigh ./NTrials) ;     SumPower = [];     SumRayleigh = [];          end     disp('saving to disk:   ')   disp([file_name '.wa.mat'])    eval([' save ' [file_name]  '.wa.mat  AvgWaPower -mat'])  	if Phase_lock_flag == 1     eval([' save ' [file_name]  '.RA.mat  PhasLockfac -mat']) 	end;    AvgWaPower = [];   PhasLockfac = [];	fclose ('all')	end;	