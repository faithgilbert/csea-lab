% mergecheckatgs%merged 2 checkatgs (was sonst)function [] = merge_emlatmeg(directory)condnames = ['4096'; '4098'; '4100'; '4102'; '4106'; '4108'];runnames = ['1';'2'];%vpnames = ['0101'; '0103'; '0104'; '0105'; '0106'; '0107'; '0108'; '0109'; '0112'; '0113']% % runs mitteln% for vp_index = 1 : 10% % 	for cond = 1 : 6	% 		FileMatIn = ([directory 'elt' vpnames(vp_index,:) 'run2.ses.msi.at' condnames(cond, :);...% 					  directory 'elt' vpnames(vp_index,:) 'run3.ses.msi.at' condnames(cond, :)])% 		FileMatOut = [directory 'elt' vpnames(vp_index,:) '.at' condnames(cond, :)]% 		MergeAvgFiles(FileMatIn,FileMatOut,2)% 	end% % end% % for cond = 1 : 8 % 	FileMatIn = [directory targnames(1,:) '_vp' vpnum_string 'at' condnames(cond, :) '.ar';...% 				 directory targnames(2,:) '_vp' vpnum_string 'at' condnames(cond, :) '.ar';...% 				 directory targnames(3,:) '_vp' vpnum_string 'at' condnames(cond, :) '.ar';...% 				 directory targnames(4,:) '_vp' vpnum_string 'at' condnames(cond, :) '.ar']% 	% 	FileMatOut = [directory 'Avg_' condnames(cond, :) '_vp' vpnum_string '.atg.ar']% 	MergeAvgFiles(FileMatIn,FileMatOut,2)% end% % % 	% % appfiles% for cond = 1 : 8% 	FileMatIn = [directory 'vp' vpnum_string targnames(1,:) '1.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(1,:) '2.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(2,:) '1.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(2,:) '2.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(3,:) '1.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(3,:) '2.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(4,:) '1.E1.app' condnames(cond, :);...% 				 directory 'vp' vpnum_string targnames(4,:) '2.E1.app' condnames(cond, :)]% 				 % 	% 	FileMatOut = [directory 'App_' condnames(cond, :) '_vp' vpnum_string '.app']% 	MergeAppFiles(FileMatIn,FileMatOut,[])% 	% end				