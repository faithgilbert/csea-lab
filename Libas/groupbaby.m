%elcvecsfunction [] = groupbaby_time(filemat)for fileindex = 1:size(infilemat,1)    elcmat = load(infile)    left_ant = [14 11 12 23 19 15 13 8 9 16 17 21 24];    left_post = [18 22 25:29 31:33 36 37];    right_ant = [1 2 53 54 3 55 56:62];    right_post = [40:52];tempmat = [];tempmat(1,:) = mean(elcmat(left_ant,:))tempmat(2,:) = mean(elcmat(left_post,:))tempmat(3,:) = mean(elcmat(right_ant,:))tempmat(4,:) = mean(elcmat(right_post,:))tempmat=tempmat'colonindex = find(infile == ':');eval([' save elnino:users:kelly:4stats' [infile(max(colonindex):length(infile))]  '.4grp  tempmat -ascii'])   