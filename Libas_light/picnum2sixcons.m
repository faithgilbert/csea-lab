% picnum2sixconsfunction [condvec, meanaromat, meanvalmat] = picnum2sixcons(infilepathmat)for fileindex = 1 : size(infilepathmat, 1)infilepath = infilepathmat(fileindex, :)	picmat = load(infilepath);picvec = picmat(:, 1);valvec = picmat(:, 2);arovec = picmat(:, 3);for picindex = 1 : length(picvec);		if picvec(picindex) < 2050 | picvec(picindex) == 3530 | (picvec(picindex) > 6250 & picvec(picindex) < 6541)	condvec(picindex) = 5;	elseif (picvec(picindex) > 2049 & picvec(picindex) < 2190) | (picvec(picindex) > 2310 & picvec(picindex) < 2361)	condvec(picindex) = 1;	elseif (picvec(picindex) > 2189 & picvec(picindex) < 2231) | (picvec(picindex) > 2361 & picvec(picindex) < 2851) | picvec(picindex) == 9070	condvec(picindex) = 3;	elseif (picvec(picindex) > 2999 & picvec(picindex) < 3131) |  picvec(picindex) == 9405	condvec(picindex) = 6;	elseif (picvec(picindex) > 4649 & picvec(picindex) < 4691) 	condvec(picindex) = 2;	elseif (picvec(picindex) > 7001 & picvec(picindex) < 7236) 	condvec(picindex) = 4;		else	condvec(picindex) = 0; disp ('error: condvec == 0'), pause	endendcondvec = condvec';for con = 1 : 6meanarovec(con) = mean(arovec(find(condvec==con)));meanvalvec(con) = mean(valvec(find(condvec==con)));endmeanarovec = meanarovec .* -1 +10;meanvalvec = meanvalvec .* -1 +10;		if fileindex == 1		meanaromat = meanarovec; 		meanvalmat = meanvalvec; 	else		meanaromat = [meanaromat; meanarovec];		meanvalmat = [meanvalmat; meanvalvec];	end	end