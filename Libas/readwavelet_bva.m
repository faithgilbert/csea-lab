function [outmat] = readwavelet_bva(filemat, nofsensors, noffrequencies);% reads a bva file (time-frequency multiplex exported file) with % time points, electrodes, and frqeuencies, % and writes it out as a matlab matrix% with 3 dimensions: time X electrodes X frequencies% good luck. if there are questions, ask akeil@ufl.edu :-) for fileindex = 1: size(filemat,1),         oldmat = load(deblank(filemat(fileindex,:)));     realmat = oldmat(:,1:2:size(oldmat,2));     imagmat = oldmat(:,2:2:size(oldmat,2));     complexmat = complex(realmat, imagmat);     mat3d = zeros(size(oldmat,1), nofsensors, noffrequencies);    sens = 1;     for start = 1:noffrequencies:nofsensors*noffrequencies;          mat3d(:,sens,:)=complexmat(:,start:start+noffrequencies-1);        sens = sens+1;    end    outmat = abs(mat3d);     save([deblank(filemat(fileindex,:)) '.mat'], 'outmat');    end % loop over files% filemat: create a list of filenames in a folder taht you want to analyze% together, to do this type% filemat = getfilesindir(pwd)  - have to in the folder where the data are% located% then you can run readwavelet_bva like this: % [outmat] = readwavelet_bva(filemat, 64, 10);% will go through the list of files and generate a mat file with the 3d% object for each. you can load into matlab ram by just clicking% will be called outmat for each file% outmat: firtst dim = time% second dim is electrodes% third dim is feqreuncies% for instance, to plot electrode 10 in a TF plot% contourf(squeeze(outmat(:,10,:))'); colorbar% to make time axis taxis = [-500:1000/512:1000-1000/512]; % freq axis faxis = [3:1:50]; %contourf(taxis, faxis, squeeze(outmat(:,10,:))'); colorbar%contourf(taxis (30:700), faxis(1:17), squeeze(outmat(30:700,10,1:17))'); colorbar % to average across electrodes and/or time (the following averages% electrodes 51, 23, 52, and 60; the '2' after the parenthesis tells it to% average over the 2nd dimension of mat3d% avgmat = squeeze(mean(outmat(:, [51 23 52 60],:),2));% plot the result% contourf(avgmat'); colorbar%submat = squeeze(outmat(:,:,1)); %the above pulls out the first wavelet (for plotting back into bva)% the following saves  it:%  save submat.dat submat -ascii;%NPTS=1792	TSB=200	DI=1.953125	SB=1	SC=1	NCHAN=64																																																										%Fp1	AF7	AF3	F1	F3	F5	F7	FT7	FC5	FC3	FC1	C1	C3	C5	T7	TP7	CP5	CP3	CP1	P1	P3	P5	P7	P9	PO7	PO3	O1	Iz	Oz	POz	Pz	CPz	Fpz	Fp2	AF8	AF4	AFz	Fz	F2	F4	F6	F8	FT8	FC6	FC4	FC2	FCz	Cz	C2	C4	C6	T8	TP8	CP6	CP4	CP2	P2	P4	P6	P8	P10	PO8	PO4	O2% to obtain stats% onenumber = mean(mean(diff(100:130, [45 30 21], 1)))% this will gicve you one number reflecting % an average over electrodes and time points% to obtain a single average for a file across time, frequencies, and% sensors, use: % onenumber = mean(mean(mean(outmat(370:550, [10 11 12 14] , 2:5))))% to average across times and frequencies, have to add the dimension to the% mean command: % onenumber = mean(mean(outmat(370:550, :, 2:5)),3)   ; this will average% across time points and frequencies, will result in electrode vector%to obtain stats on multiple files, put the .mat files in a new directory%(working directory). run:%filemat = getfilesindir(pwd)%then run the following to loop through each, in the order they are in the%filemat%for fileindex = 1: size(filemat,1), %load(deblank(filemat(fileindex,:))); %statsvec(fileindex) = mean(mean(mean(outmat(370:550, [10 11 12 14] , 2:5)))); %end % to adjust the colorbar/color resolutioh of the tf plot % caxis command -> see help caxis %to get values, type: %statsvec  % to save a variabkle that you generated (e.g stats) in ascii,  %type save 'name.dat' statsvec -ascii 