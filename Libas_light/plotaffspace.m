function [] = plotaffspace(arovec, valvec) figureaxis([1 9 1 9])hold onxlabel('arousal')ylabel('valence')for index = 1 : 90	plot(arovec(index), valvec(index), '*r')	h= text(arovec(index), valvec(index), num2str(index))	set(h,'color', 'k')	set(h,'FontSize', 16)		%pause		end