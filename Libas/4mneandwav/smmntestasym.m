sensor_name = '/export/jesse/data3/SMMN/rawdata/01wut.pmg';cos_name = '/export/jesse/data3/SMMN/rawdata/01wut.cot';infiles(1,:) = '01wut.avr       ';inpaths(1,:) = '/export/jesse/data3/SMMN/rawdata/';[namelist, paths, names] = experimenter_mn_meg(sensor_name, cos_name, inpaths, infiles, '/export/jesse/data3/SMMN/', -100, 400); 