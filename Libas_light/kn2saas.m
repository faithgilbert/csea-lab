function [x] = kn2saas(band);% function [] = kn2sa%% Funktion oeffnet mit feige2kn.m ein file und wandelt dieses% in eine hierarchische Struktur%%        --------  Elektroden -----------------%        ----- Bedingungen -------------------%        - Zeitfenster ---------------------%% -Vps in Zeilen% -das ausgewaehlte Band wird gemittelt%% Parameter sind vom User im Quelltext einzutragen%% August 1997 - T.Gruber%n_zeitfenster = 16elektroden = [11 68];			% [] : alle E.mittel_e   = 0;        		% 1  : Elektroden mitteln		       				% 0  : Elektroden nicht gemittelt	 mittel_vp = 0         		% 1 = Alle Vps mitteln                      		% 0 = jede Vp als einzelne Zeile%zeit_f     = [1 32]	               % Zeitfenster, die zusammengefasst werden									% sollen%zeit_f = timeveczeit_f = [1 1 ; 3 3; 5 5; 7 7; 9 9; 11 11; 13 13]%zeit_f = [1 1;2 2;3 3;4 4;5 5;6 6;7 7;8 8;9 9;10 10;11 11;12 12; 13 13;%        14 14; 15 15; 16 16;17 17;18 18; 19 19; 20 20; 21 21; 22 22; 23 23;%		  24 24; 25 25; 26 26; 27 27; 28 28; 29 29; 30 30; 31 31; 32 32];%		   33 33; 34 34; 35 35; 36 36; 37 37; 38 38; 39 39; 40 40; 41 41;%		   42 42; 43 43; 44 44; 45 45; 46 46; 47 47; 48 48; 49 49; 50 50;%		   51 51; 52 52; 53 53; 54 54; 55 55; 56 56; 57 57; 58 58; 59 59;%		   60 60; 61 61; 62 62; 63 63; 64 64]%zeit_f = [5 8;9 12;13 16;17 20;21 24]%zeit_f = [1 4;5 8;9 12;13 16;17 20;21 24;25 28;29 32]%zeit_f = [2 3; 16 17; 25 26; 29 30]%vps = ['04';'05';'06';'07';'08';'09';'10';'11';'12';'14']vps = ['04';'05';'06';'07';'08';'09';'11';'16';'17';'21'];%ascii1_name                        	% Ascii File fuer erzeugte Strukturascii2_name = []		% Ascii File f�r Matrix zum plottenbild = 0		        % 1 = Struktur wird gezeichnet		                % 0 = Struktur wird nicht gezeichnet	% ! Pfade 5 Zeilen weiter unten eintragen% Hauptschleife; alle Vps durchgehenx = [];x_bild = [];%bedvec = ['Brot';'Rrot']%bedvec = ['Bsad'; 'Bsun']% bedvec = ['Rface'; 'Rvase'] bedvec = ['neg';'neu'; 'pos'];%for bednum = 1 : 2	for bednum = 1 : 3	bed = bedvec(bednum,:)x = [];	for hs = 1 : size(vps,1)  vp = vps(hs,:);%    	files = [bed(bednum,:) vp '.E1.appg.mfx.dat'] files = [ 'IA' vp bed '.appg.mfx.ASC'];%   files = [ bed vp '.E1.appg.mfx.dat'];%   files = ['Rrot' vp '.E1.appg.mfx.dat';];  %	files = ['Bsad' vp '.E1.appg.mfx.dat';];		%	files = ['Bsun' vp '.E1.appg.mfx.dat';];	%	files = ['Rface' vp '.E1.appg.mfx.dat';];	%	files = ['Rvase' vp '.E1.appg.mfx.dat';];	    pfad = ['UBIES:AS_Exps:iapsgam:resfreq_ohneEP']     % Alle Bedingungen einer Vp durchgehen  erg_bed = [];  for n_files = 1 : size(files,1)      erg =[];            datei = [ pfad ':' files(n_files,:) ]     [SFreq,Nr_of_averages,channels,points,zf,frequenzen,erg] = feige2kn(datei,band);	    % nicht ausgewaehlte Elektroden loeschen, in richtige Reihenfolge bringen    % und optional mitteln    if isempty(elektroden) elektroden = 1:channels; end;    erg_dummy = [];    for i = 1 : size(elektroden,2)      erg_dummy = [erg_dummy erg(:,elektroden(i))];    end;    erg = erg_dummy;    	% Exponieren    %if expo == 1 erg = exp(erg); end;		channels = size(elektroden,2);    if mittel_e == 1 erg = mean(erg')';channels = 1;end;    % Ende : nicht ausgewaehlte Elektroden loeschen,in richtige Reihenfolge bringen    %        und optional mitteln  	      % Mitteln des ausgewaehlten Bandes    erg_dummy = [];    if band(1) ~= band(2)      for i = 1 : (band(2)-band(1)+1) : n_zeitfenster*(band(2)-band(1)+1)		erg_dummy = [erg_dummy; mean(erg(i:i + band(2)-band(1),:))];      end;      erg = erg_dummy;    end;        % Ende : Mitteln des ausgewaehlten Bandes        % Zusammenfassen von Zeitfenstern        erg_dummy  = [];    if  ~isempty(zeit_f)      for l1 = 1:size(zeit_f,1)        if zeit_f(l1,1) == zeit_f(l1,2)          erg_dummy = [erg_dummy;erg(zeit_f(l1,1),:)];         else          erg_dummy = [erg_dummy;mean(erg(zeit_f(l1,1):zeit_f(l1,2),:))];        end;      end;      erg = erg_dummy;    end;            % Ende : Zusammenfassen von Zeitfenstern        % erg hat nun folgende Struktur    %     %         E1 E2 E3 ....     % Zeitf.1    % Zeitf.2    % ...    %      % Frequenzbaender sind gemittelt    %        % Umsortieren    erg_dummy = [];    for l = 1 : channels      erg_dummy=[erg_dummy erg(:,l)'];    end;    erg = erg_dummy;    % Ende : Umsortieren        %    % erg hat nun folgende Struktur (nur eine Zeile)      %    % Elektrode1 Elektrode2 ....    % Zf1 ZF2 ..      %    erg_bed = [erg_bed erg];    end;   % Ende : Alle Bedingungen einer Vp durchgehen  %   % die Struktur von erg_bed sieht nun folgendermassen aus :   % ( ein ZEILENVEKTOR )  %  %        --------  Bedingungen -------------  %        ----- Elektroden -------------------  %        - Zeitfenster ---------------------  %  % um das endgueltige Erg herzustellen muss also nochmals umgestellt werden   %    erg_dummy = [];  for nd = 1 : size(zeit_f,1) : channels * size(zeit_f,1)    for nb = 1 : size(zeit_f,1) * channels : size(zeit_f,1) * channels * size(files,1)       erg_dummy = [erg_dummy, erg_bed( nb+nd-1 : nb+nd-1+ size(zeit_f,1)-1) ];    end;  end;       x = [x;erg_dummy];     end; % Ende : Hauptschleife; alle Vps durchgehen% Vps mittelnif size(vps,1) ~= 1  if mittel_vp == 1    x = mean(x);  end; end;% Ergebnis Struktur als speichern%if ascii1_name ~= []  		%cd Fx    %x1=x;	%s = ['load '[ascii1_name]];	%eval(s);	%x=[x;x1];		%  s = ['save ' [ascii1_name '.ASC'] ' x -ascii;' ];%  eval (s);    %cd ..  % end;size(x)fname = ([bed 't_alph'])eval(['save UBIES:AS_Exps:iapsgam:resalpha_t:' fname ' x -ascii']) end