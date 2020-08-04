% generates morlet wavelets with given frequency range etc.function [wavelet,cosine] = gener_wav_fast(NPointsnew, NPointsold, delta_f0, f0_start, f0_end,paramm,Ncosinetaper);%(c) Gruber & Keil, 1847, Gruber 2005real_f0_vec = [];index = 1;for f0 = f0_start : delta_f0 : f0_end    %   ueber  Peakfrequenz der Wavelets : index f0 bis nyquist    real_f0_vec = [real_f0_vec f0];    sigma_f = f0 / paramm;    A = 1/(sqrt(sigma_f * sqrt(pi)));    for f = 1:NPointsnew  ;        wavelet(index, f) = Agauss(f0,sigma_f, A, f);    end    index = index+1;endsquarecos1 = (cos(pi/2:(pi-pi/2)/Ncosinetaper:pi-(pi-pi/2)/Ncosinetaper)).^2;squarecos2 = (cos(0:(pi-pi/2)/Ncosinetaper:pi/2-(pi-pi/2)/Ncosinetaper)).^2;dummy1= NPointsold - length(squarecos2) - length(squarecos1);dummy2= NPointsnew - NPointsold ;cosine = [squarecos1 ones(1,dummy1) squarecos2 zeros(1,dummy2)];wavelet = wavelet.';