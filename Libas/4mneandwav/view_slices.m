% View 4D-function in slices% xyz contains the 3D-locations, v contains the corresponding function values% xyz,v must be ordered such that values belonging to one z-slice are neighboured% The xy-plane must be regularly spaced, the z-slices should be regularly spaced% Only slices with more than 1 element are viewed% The subplots corresponding to different slices are organized in a matrix, the same colourcoding is used% for all subplots% OH 30.10.97% uses view_slicefunction view_slices(xyz, v);if nargin==0,   disp(' view_slices(xyz, v); ');end;if length(v)~=length(xyz(1,:)), 	disp(' Length of coordinate vector and function value vector do not match!!! (view_slices) ');	return;end;tol = 1.0e-6; 	% Tolerance for grid locationscnt = 1;	% Find grid distancefor i = 2:min(length(v),10),	d = abs(xyz(1,i)-xyz(1,i-1));	if d>tol,		dist(cnt)=d;		cnt = cnt+1;	end;end;distance = min(dist);zcnt = 1;		% Find different slices by comparing z-valuesz(zcnt) = xyz(3,1);indices(zcnt) = 1;for i=2:length(xyz(1,:)),	if abs(xyz(3,i)-z(zcnt))>distance/10,		zcnt = zcnt + 1;		indices(zcnt) = i;		z(zcnt) = xyz(3,i);			end;end;indices(zcnt+1) = length(v)+1;zvalid = 0;			% Counting slices with more than 1 elementfor i=1:zcnt	if (indices(i+1)-indices(i))>1,		zvalid = zvalid + 1;	end;end;s = sqrt(zvalid);	% Find appropriate dimensions for the subplot matrixif round(s)==s	plotrows = round(s);	plotcols = round(s);else	for i=1:ceil(s),		if i*ceil(s)>=zvalid,			plotrows = ceil(s);			plotcols = i;			break; 		end;	end;end;maxvalue = max(v);cnt = 1;for i=1:zcnt			% Create subplots for slices	if (indices(i+1)-indices(i))>1,		subplot(plotrows,plotcols,cnt);		zslice = num2str(z(i));		view_slice( xyz(1:2,indices(i):indices(i+1)-1), v(indices(i):indices(i+1)-1), 0, maxvalue );      title(zslice);      axis square;		cnt = cnt+1;	end;end;colorbar;	