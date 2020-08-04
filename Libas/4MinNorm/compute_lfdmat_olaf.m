% Computes leadfield matrix for given dipole locations (loc_mat(3,nr_dip))% and electrode locations (on unit sphere) (sens_mat(3, nr_sens))% A model flag can be set (see below)% For every dipole location, three (xyz) or two (dphi, dtheta) leadfield components are computed% => lfd_mat(nr_sens, (2,3)*nr_dip)% For MEG, a centre of sphere (cntr_of_sphere(1,2,3)) can be specified, "loc_mat" should be % centred around (0,0,0) !!! For MEG, x and y coordinates are swapped (BTI) !% Unit of dipole strength: 1nAm (tested with ASA)% OH 23.10.97, 03.12.97, 18.12.97, 29.01.98, 09.02.98, 11.02.98, 01.06.99% uses lf34capr() of rgpm (EEG)  or  sphere_meg() (MEG)function [lfd_mat, orientations, v] = compute_lfdmat_olaf(loc_mat, sens_mat, method_flag, coor_flag, cntr_of_sphere);if nargin==0,   disp(' [lfd_mat, orientations, v] = compute_lfdmat(loc_mat, sens_mat, method_flag, coor_flag, cntr_of_sphere); ');   return;end;[ml nl] = size(loc_mat);[ms ns] = size(sens_mat);if nargin==2 | strcmp(method_flag, 'EEG') | strcmp(method_flag, 'eeg'),    for i=1:nl,       if mod(i,100)==0, disp(i); end;		for j=1:ns,         lead = lf34capr(sens_mat(1:3,j), loc_mat(1:3,i));         if strcmp(coor_flag, 'xyz'),            lfd_mat(j, 3*(i-1)+1:3*i) = lead';            orientations(:,3*(i-1)+1:3*i) = [1 0 0; 0 1 0; 0 0 1];         end;         if strcmp(coor_flag,'sph'),            np(1) = -loc_mat(2,i);            % Tangent to circle in x-y-plane (dr/dphi)            np(2) = loc_mat(1,i);            np(3) = 0.0;            normnp = norm(np);            if normnp>10*eps, 			% If not on z-axis               np = np/normnp;            else               np = [1 0 0];            end;            rxy = sqrt(loc_mat(1,i)*loc_mat(1,i)+loc_mat(2,i)*loc_mat(2,i));            nt(1) = np(2)*loc_mat(3,i);               nt(2) =                     -np(1)*loc_mat(3,i);                    nt(3) = np(1)*loc_mat(2,i) - np(2)*loc_mat(1,i);                    nt = nt/norm(nt);            nr = loc_mat(:,i)/norm(loc_mat(:,i));            lfd_mat(j,3*(i-1)+1) = lead'*np';            lfd_mat(j,3*(i-1)+2) = lead'*nt';            lfd_mat(j,3*(i-1)+3) = lead'*nr;            orientations(:,3*(i-1)+1) = np';            orientations(:,3*(i-1)+2) = nt';            orientations(:,3*(i-1)+3) = nr;         end;  % if coor_flag		end;  % for j   end;  % for i   lfd_mat = lfd_mat/50;		% Unit of dipole strength: 1nAmend;	% if EEGif strcmp(method_flag, 'MEG') | strcmp(method_flag, 'meg'),   if ~isempty(cntr_of_sphere),      tmp = sens_mat;      sens_mat(1,:) = -tmp(2,:)+cntr_of_sphere(2);      sens_mat(2,:) = tmp(1,:)-cntr_of_sphere(1);      sens_mat(3,:) = tmp(3,:)-cntr_of_sphere(3);      sens_mat(4,:) = -tmp(5,:);      sens_mat(5,:) = tmp(4,:);      sens_mat(6,:) = tmp(6,:);      clear tmp;   end;   for i=1:nl      if mod(i,100)==0, disp(i); end;      for j=1:ns         lead = sphere_meg(sens_mat(1:3,j), sens_mat(4:6,j), loc_mat(1:3,i));         if strcmp(coor_flag, 'xyz'),            lfd_mat(j, 3*(i-1)+1:3*i) = lead;          end;         if strcmp(coor_flag, 'sph'),            if norm(loc_mat(1:3,i))<10*eps,               np = [1 0 0];               nt = [0 -1 0];            else,            	np(1) = -loc_mat(2,i);            % Tangent to circle in x-y-plane (dr/dphi)	            np(2) = loc_mat(1,i);	            np(3) = 0.0;	            normnp = norm(np);	            if normnp>10*eps, 			% If not on z-axis	               np = np/normnp;	            else	               np = [1 0 0];	            end;	            rxy = sqrt(loc_mat(1,i)*loc_mat(1,i)+loc_mat(2,i)*loc_mat(2,i));	            nt(1) = np(2)*loc_mat(3,i);   	            nt(2) =                     -np(1)*loc_mat(3,i);        	            nt(3) = np(1)*loc_mat(2,i) - np(2)*loc_mat(1,i);                       nt = nt/norm(nt);				end; 		% if norm(loc_mat...   	         lfd_mat(j,2*(i-1)+1) = lead*np';	         lfd_mat(j,2*(i-1)+2) = lead*nt';	         orientations(:,2*(i-1)+1) = np';            orientations(:,2*(i-1)+2) = nt';         end;  % if strcmp(coor_flag...      end;  % for j   end;  % for i   lfd_mat = lfd_mat/0.0003145;			% Unit of dipole magnitude: 1nAmend;	% if MEG[m n] = size(lfd_mat)   if strcmp(coor_flag, 'sph'),			% Volumes for weighting of leadfield columns   if strcmp(method_flag, 'EEG') | strcmp(method_flag, 'eeg'),       dim = 3;   else,      dim = 2;   end;   [q, r] = when_changes_radius(loc_mat(1:3,:), 0.001);   elem = 1;   for j=1:length(q),      if j==length(q),   	   volume = (4.0/3.0)*pi*(r(j)^3)/(q(j)-q(j-1));         v(elem:dim*q(j)) = volume;      elseif j==1,         volume = (4.0/3.0)*pi*(r(1)^3-r(2)^3)/q(1);         v(1:dim*q(1)) = volume;         elem = dim*q(1)+1;		else   	   volume = (4.0/3.0)*pi*(r(j)^3-r(j+1)^3)/(q(j)-q(j-1));                 v(elem:dim*q(j)) = volume;         elem = dim*q(j)+1;      end;   end;   if n~=length(v),      disp(' Number of volume elements and number of columns of leadfield matrix do not match !!! (compute_lfdmat) ');      return;   end;   for i=1:m,      lfd_mat(i,:) = lfd_mat(i,:).*v;   end;end;