% getcondveceprime% searches condnumberes in e-prime *.txt filefunction [convec4EEG] = getcon_ssvepiaps_std14(filepath);contentvec = []; fid = fopen(filepath)a = 1adventure = [5470,5621,5629,8031,8080,8158,8161,8163,8179,8180,8186,8190,8200,8206,8210,8260,8300,8341,8370,8492];romance = [4597  4598 4599 4600 4610 4612 4616 4619 4624 4625 4626 4628 4640 4641 4643 4645 4650 4653 4660 4700]; erotica = [4210 4220 4311 4490 4604 4611 4658 4659 4668 4669 4680 4687 4690 4692 4693 4694 4695 4697 4698 4800]; neutralanimals = [1122,1333,1419,1450,1505,1595,1602,1605,1645,1670,1675,1740,1812,1900,1903,1908,1910,1942,1945,1947]; neutralfaces = [2002 2019 2025 2032 2101 2104 2105 2107 2190 2200 2210 2211 2220 2221 2305 2383 2397 2441 2484 9070];neutralpeople = [2026  2036 2037 2038 2102 2191 2235 2272 2273 2359 2374 2377 2382 2384 2390 2393 2396 2411 2488 2489]; animalattack = [1019 1026 1033 1050 1052 1080 1090 1111 1113 1114 1120 9991 9992 9993 9994 9995	9996 9997 9998 9999];humanattack = [2811,3500,3530,6230,6231,6312,6260,6263,6313,6315, 6350,6510,6520,6550,6560,6570,9413,9423,9414,9940];mutilation = [3000,3001,3019,3030,3051,3053,3059,3060,3064,3068,3069,3071,3080,3110,3102,3150,3170,3213,3261,3400]; 	 while a > 0	    a = fgetl(fid);        if a > 0;  	   blankvec = findstr(a, ' ')       picnum = str2num(a(max(blankvec)+1:max(blankvec)+5))    if ismember(picnum,adventure), contentvec = [contentvec 1];    elseif ismember(picnum,romance), contentvec = [contentvec 2];    elseif ismember(picnum,erotica),  contentvec = [contentvec 3];    elseif ismember(picnum,neutralanimals), contentvec = [contentvec 4];    elseif ismember(picnum,neutralfaces), contentvec = [contentvec 5];    elseif ismember(picnum,neutralpeople), contentvec = [contentvec 6];    elseif ismember(picnum,animalattack),contentvec = [contentvec 7];    elseif ismember(picnum,humanattack), contentvec = [contentvec 8];    elseif ismember(picnum,mutilation), contentvec = [contentvec 9];    else contentvec = [contentvec 99]; pause    end    end end contentvec = contentvec';convec4EEG = contentvec;fclose('all')eval(['save ' filepath '.con convec4EEG -ascii'])