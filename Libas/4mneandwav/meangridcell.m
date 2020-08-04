function outvalmat = meangridcell (inmat, nmf1, nmf2, nmt1, nmt2)% compute mean over frequency-band and time-frame% first compute indices from real times and real frequencies f1 = 1+(nmf1-8)/2;f2 = 1+(nmf2-8)/2; %2hz steps, beginning from 8 hz.t1 = round(26+(nmt1+300)/1.9661); %26 warm up for wa, 300 baseline in ms, 1/1.9661 samplefreqt2 = round(26+(nmt2+300)/1.9661);  % structure of wavelet matrix: x = chnls, y = freq, z = time% first mean over freqfreqmat = zeros(size(inmat,1), size(inmat,3));%disp(size(freqmat));for i=f1:f2   freqmat(:,:) = freqmat(:,:) + squeeze(inmat(:,i,:));endfreqmat = freqmat /(1+f2-f1);%now mean over time[x1,x2, x3] = size(inmat);outvalmat = zeros(x1,1);%disp(size(outvalmat));for i=t1:t2   outvalmat(:) = outvalmat(:) + squeeze(freqmat(:,i));endoutvalmat = outvalmat/(1+t2-t1);