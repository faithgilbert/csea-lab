% fuehrt normalisierung durch nach McCarthy and wood /input ;ein sa file% i.e. fuer jede zeile wird ein maximum und minimum ermittelt,% ein normalisierter wert wird bestimmt nach neu = (x - min)/(max - min)%clear[file, path] = uigetfile ('ubies:iapsgam:safiles:*', 'name of file     ')eval (['load ' path file])vollmat = eval (file);a = size(vollmat)nrows = a(1);%Zeitpunkte/bedingungen durchgehenfor bed = 0 : 129 : length(vollmat)-129teilmat = vollmat(:,(bed+1 : bed+129));% eine bedingung, jeweils eine zeile (vp) ueber alle elektroden normierenfor row = 1 : nrows	minimum = min(teilmat(row,:));	maximum = max(teilmat(row,:));	for col = bed+1 : bed+129		neumat(row,col) = (vollmat(row,col)-minimum)/(maximum - minimum);	endendendsize (neumat)resfile = ([file 'MW']);disp ('saving file')disp (resfile)   eval (['save ubies:iapsgam:safiles:'resfile	' neumat -ascii'])