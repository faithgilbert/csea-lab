% berechnet Meanpotentials aus ATG.ar konstanz file fuer ein anzugebendes Zeit-% fenster im Batchbetriebfunction [] = Scads2meanpot(trans, bed, ascii1_name, timevec, bslvec);%clearif nargin < 5	bslvec = [];endif nargin < 4	timewins = 1;	disp('first point only ')	pauseendif nargin < 3ascii1_name = input ('ascii name for result?      ','s')endif nargin < 2bed = input ('name of condition?         ','s')endif nargin <1trans = 'n'end%timewins = [425 475]  % N1ipsi in emolat= [228: 243] =>155-186ms					  % p300 in emolat= [280: 300]	=>260-300ms							  % LPC in emolat = [325: 375] => 350-450ms					  % P1contra  = [190: 200] => 80-100ms					  % P1ipsi = [200 :210] => 100-120ms					  % N1contra = [210 :220] => 120-140ms					  % Nanterior = [250: 300] => 200-300ms					  % spaetst = [400:512] =>500-722ms					  % timevec iapsMn300_1000:	 p1 : [90:100] = 72 bis 92%							 N1	: [108:113]=130 bis 150 ms%							P3a : [150:160] = 300 bis 340 ms%							P3b : [175:185] = 400 bis 440 ms%							Sw1 : [225:250] = 600 bis 650 ms%							Sw2 : [288:312] = 750 bis 850 ms%timewins = input (' time window to select and average? (in samppoints) (form: [x y; a b; etc])    ');%trans = input ('transformiere nach MCCarthy and wood (y/n)?   ','s')%bslvec = [49:149];%bslvec = input('baseline (sample points a:b)      ');%vps = ['IA01';'IA04';'IA05';'IA06';'IA07';'IA08';'IA09';'IA11';'IA16';'IA17';'IA21']; % IAPS%vps = ['02';'04';'05';'06';'07';'08';'09';'10';'11';'12';'14'];  %brot%vps = ['HS97001_';'HS97003_';'HS98005_';'HS98009_';'HS98011_';'HS98013_';'NS98004_';'NS98006_';'NS98007_';'NS98008_';'NS98010_'; 'NS98012_'];   %hypno%vps = ['02';'05';'07';'09';'10';'11';'14';'15';'16';'17'] % emolat%vps = ['01';'02';'04';'05';'06';'07';'08';'09';'10';'11';'12']vps = ['02';'03';'04';'05';'06';'07';'08';'11';'13';'15']; %checkersascii1_name pfad = ['ElNino:AS_Exps:checkers:ERPs']%  pfad = ['UBIES:iaps:atgfiles']% pfad = ['UBIES:bruno:erps']for vpindex = 1 : size(vps,1)   % schleife ueber subjects  vp = vps(vpindex,:); file = [ 'vp' vp  bed '.E1.at.ar.f'];   % checkers %file = [ vp '.Merge.at' bed '_300_1000MN']   % IAPS%file = [ bed vp '.fl40.E1.atg.ar' ]  FilePath = [ pfad ':' file]% baseline abziehen[ERPmat] = ReadAvgFile(FilePath);   % liest einif ~isempty(bslvec);		for chan = 1 : 129	BslCorMat(chan,:) = ERPmat(chan,:)-mean(ERPmat(chan,bslvec));	endelse	BslCorMat = ERPmat;end% berechne  meanpotentials  % transformiere nach MCCarty and wood        if trans == 'y'        for t = 1 : length (BslCorMat);            teilmat = BslCorMat(:,t);            minimum = min(teilmat);            maximum = max(teilmat);                        for elek = 1 : 129                neumat(elek, t) = (BslCorMat(elek,t)-minimum)/(maximum - minimum);            end        end    else neumat = BslCorMat;	end	    % schreibe gemittelte werte fuer jede elektrode in superanova-format 	ERPneuvec1 = mean(neumat(:,[timevec])');ERPsamat (vpindex, [1:129]) = ERPneuvec1;end if trans == 'y'	 ascii1_name = ([ascii1_name 'MW']); end eval(['save ElNino:temp:'ascii1_name ' ERPsamat -ascii'])%eval (['save ubies:As_exps:Hypnosis_pain:fuerstatsneu:'ascii1_name ' ERPsamat -ascii'])  % hypno%eval (['save ubies:iaps:fuer_stats:'ascii1_name ' ERPsamat -ascii']) %IAPSdisp ('saving file'), disp (ascii1_name)clear 