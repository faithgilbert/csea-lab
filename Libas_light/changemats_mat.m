% avgmats% average .mat files specified in filematinfunction [] = changemats_mat(filematin)for fileindex = 1 : size(filematin, 1)		load(filematin(fileindex, :)); 		disp(filematin(fileindex, :))		size(AvgWaPower)		AvgWaPower = AvgWaPower(:, :, 1:4:512);		eval(['save ' filematin(fileindex, :) ' AvgWaPower -mat'])	end