% topottest% [topo_tmat, mat3d_1, mat3d_2] = topottest(filemat1, filemat2, bslvec,% outname)function [topo_tmat, mat3d_1, mat3d_2] = topottest_ant(filemat1, filemat2, bslvec, outname)if nargin < 4;     outname = []; end [dat] = read_eep_avr(deblank(filemat1(1,:)));  a = dat.data; mat3d_1 = zeros(size(a,1), size(a,2), size(filemat1,1) ); mat3d_2 = zeros(size(a,1), size(a,2), size(filemat1,1) ); for subject = 1:size(filemat1,1);      [dat] = read_eep_avr(deblank(filemat1(subject,:)));  a = dat.data;        if ~isempty (bslvec)    mat3d_1(:,:, subject) = bslcorr(a, bslvec);    else       mat3d_1(:,:, subject) = a;    end          [dat2] = read_eep_avr(deblank(filemat2(subject,:)));     b = dat2.data;           if ~isempty (bslvec)        mat3d_2(:,:, subject) = bslcorr(b, bslvec);       else          mat3d_2(:,:, subject) = b;       endend[dummy, dummy, dummy, stats] = ttest(mat3d_2, mat3d_1, 0.05, [], 3); topo_tmat = stats.tstat; eval(['save ' outname ' topo_tmat -mat'])    