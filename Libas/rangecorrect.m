%rangecorr
% transforms a vector of numbers into range-corrected values using lykken
% range correction: (x-min)/(max-min) 
function [out] = rangecorrect(invec) 

out = (invec -mean(invec)) ./ (max(invec) - min(invec)); 
