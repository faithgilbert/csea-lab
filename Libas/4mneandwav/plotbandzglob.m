function plotbandzglob(facmat,armmat,legmat)% left hemi leg, arm, facsubplot(2,3,1)% chnls 3,4,10,11,12,13holdplotband(facmat, 30,90,[], [0 0 1] );plotband(armmat, 30,90,[], [1 0 0] );plotband(legmat, 30,90,[], [0 1 0] );line([0 462],[0 0], 'color', [0 0 0]);subplot(2,3,2)% chnls 23,24,25,41,42,43holdplotband(facmat, 30,90,[], [0 0 1] );plotband(armmat, 30,90,[], [1 0 0] );plotband(legmat, 30,90,[], [0 1 0] );line([0 462],[0 0], 'color', [0 0 0]);subplot(2,3,3)% chnls 62,63,64,85,86,87holdplotband(facmat, 30,90,[], [0 0 1] );plotband(armmat, 30,90,[], [1 0 0] );plotband(legmat, 30,90,[], [0 1 0] );line([0 462],[0 0], 'color', [0 0 0]);% right hemi, leg, arm, facsubplot(2,3,4)%chnls 6,7,15,16,17,18holdplotband(facmat, 30,90,[], [0 0 1] );plotband(armmat, 30,90,[], [1 0 0] );plotband(legmat, 30,90,[], [0 1 0] );line([0 462],[0 0], 'color', [0 0 0]);subplot(2,3,5)% chnls 32,33,34,52,53,54holdplotband(facmat, 30,90,[], [0 0 1] );plotband(armmat, 30,90,[], [1 0 0] );plotband(legmat, 30,90,[], [0 1 0] );line([0 462],[0 0], 'color', [0 0 0]);subplot(2,3,6)% chnls 75,76,77,100,101,102holdplotband(facmat, 30,90,[], [0 0 1] );plotband(armmat, 30,90,[], [1 0 0] );plotband(legmat, 30,90,[], [0 1 0] );line([0 462],[0 0], 'color', [0 0 0]);