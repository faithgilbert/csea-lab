%erzeuge freq * t matrix fuer Contourplot aus matrix 800X129% !!!!!!! Achtung Thomas : in Zeilen 40/41 sind frq und t vektoren, die du vielleicht % !!!!!!!! aendern musst INput Format: Elektroden als Spalten und zeit/freq als zeilen%m = zeros(1,800);vps = ['02';'04';'05';'06';'07';'08';'09';'10';'11';'12';'14'];%for vp = 1 :11%file = input ('name of file     ','s')%file = (['brot'vps(vp,:)])lo = input('load new matfile? [y/n]       ','s')if lo == 'y'		clear		[File, Path] = uigetfile('ubies:bruno:in_arbeit:*')		Filepath = [Path File]		eval(['load 'Filepath]) 		vollmat = eval(File);endelvec = input('average electrodes ? Nrs. in VecForm [1:129] = all      ');if length(elvec) > 1tfreqvec = mean(vollmat(:,elvec)');elsetfreqvec = (vollmat(:,elvec));endmeshmat = reshape(tfreqvec, 25, 32);meshmatnolap = meshmat(:,[4:32]);t = [384:168:5088];freq = [0:3.9:95];freqrange = input('frequency range ? [band1:band2]   ');%titlstring = input('title string ?       ','s') colormap(flipud(gray))figure(1)contourf(t,freq(freqrange),meshmatnolap((freqrange),:),length(freqrange)*2);,caxis([0.1 0.4])colorbarxlabel('time (ms)')%ylabel('frequency (Hz)')%title(titlstring)