% Ttest.m erhaelt zwei vektoren%	berechnet T-wert und gibt ihn und a>b greatFlag = 1 oder b>a greatFlag = -1 ausfunction[tVal, greatFlag] = Ttestwithin(vector1, vector2)% 1. berechne ML-schaetzer fuer standardfehler der differenzendfx = length(vector1) - 1;dfy = length(vector2) - 1;dfe  = dfx + dfy;msx = dfx * (std(vector1))^2;msy = dfy * (std(vector2))^2;difference = mean(vector1-vector2);sumdiff1 = sum((vector1-vector2).^2);sumdiff2 = ((sum(vector1-vector2)).^2)./(length(vector1));vector1-vector2;sqrvec = ((vector1-vector2)-difference) .^2;sum(sqrvec);sigmadach_1 = sqrt((sumdiff1 - sumdiff2) ./ dfy);sigmadach = sigmadach_1/sqrt(length(vector1));tVal =  difference / sigmadach;% 3. bestimme greatFlagif mean(vector1)> mean(vector2)   greatFlag = 1;elseif mean(vector2)> mean(vector1)   greatFlag = -1;else   greatFlag = 0;end