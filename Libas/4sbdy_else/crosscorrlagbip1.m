% berechnet Crosscorr mit neg und pos lag fuer P 50 und evoz. gamma, stellt correlogram dar%im stil von singer diagrammcleardisp('select files')summatp50 = zeros(600,8);sumgammat = zeros(600,8);VPcrosslagmat = [];% files einlesenfor vp = 1:10	[p50file, p50path] = uigetfile('ubies:fremdstuff:niko:*.asc', 'select p50file');[gamfile, gampath] = uigetfile('ubies:fremdstuff:niko:*.asc', 'select gamma file');disp (' Autocorrelation function')lengthp50fname = length(p50file)-4;lengthgamfname = length(gamfile)-4;p50filepath = ([p50path p50file]);gamfilepath = ([gampath gamfile]);load (p50filepath)load (gamfilepath)p50mat = eval(p50file(1:lengthp50fname));gammat = eval(gamfile(1:lengthgamfname));summatp50 = summatp50 + p50mat;sumgammat = sumgammat + gammat;crosslagmat = zeros(2,25);for channel = 1 : 2	for lag = 0 : 24		p50chanvec = p50mat([100:220],channel);		p50corrdummy = corrcoef(p50chanvec(1:length(p50chanvec)-lag), p50chanvec(lag+1 : length(p50chanvec)));		p50chancorvec(lag+1) = p50corrdummy(1,2);				gamchanvec = gammat([100:220],channel);		gamcorrdummy = corrcoef(gamchanvec(1:length(gamchanvec)-lag), gamchanvec(lag+1 : length(gamchanvec)));		gamchancorvec(lag+1) = gamcorrdummy(1,2);				crosslagdummy = corrcoef(p50chanvec(1:length(p50chanvec)-lag), gamchanvec(lag+1 : length(p50chanvec)));		crosslagvec(lag+1) = crosslagdummy(1,2);	end		crosslagmat(channel,:) = crosslagvec ;     	end% time scale for neagtive and positive lag:ntpoints = length(crosslagvec)*2;tvecplot = [-ntpoints/2+1  : ntpoints/2-1];tvecplotms = tvecplot.*2;crossneglagmat=fliplr(crosslagmat);correlogrammat = [crossneglagmat(:,[1:(ntpoints/2)-1]) crosslagmat];disp ('press key to plot results')% setup fuer title und x-axistitlestring = [p50file(7:8)];figure(1),subplot(2,5,vp), plot(tvecplotms, correlogrammat(1,:),'k-')hold onsubplot(2,5,vp), plot(tvecplotms, correlogrammat(2,:),'k--')axis([-50 50 -1 1])hold onplot (tvecplotms, 0.325, 'k-')plot (tvecplotms,-0.325,'k-')plot (tvecplotms, 0.25, 'k.')plot (tvecplotms, -0.25, 'k.')hold offxlabel('time lag (ms)')title(titlestring)pauseVPcrosslagmat = [VPcrosslagmat; crosslagmat]end % ende vpssummatp50end = summatp50./9;sumgammatend = sumgammat./9;% VPcrosscoorlag fuer elektroden getrenntVpcrosslagmatFZ = VPcrosslagmat([1:2:19],:);VpcrosslagmatCZ = VPcrosslagmat([2:2:20],:);for vp = 1 : 10FZcycle(vp) = find(VpcrosslagmatFZ(vp,:) == max(VpcrosslagmatFZ(vp,[3:25])))CZcycle(vp) = find(VpcrosslagmatCZ(vp,:) == max(VpcrosslagmatCZ(vp,[3:25])))endVPcorrCZ = VpcrosslagmatCZ(:,1)VPcorrFZ = VpcrosslagmatFZ(:,1)