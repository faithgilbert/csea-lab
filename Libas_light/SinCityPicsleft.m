% filterpics
function [distmat] = SinCityPicsleft(filemat, pixelpercentage); % pixelpercentage is a decimal ratio, e.g., .05

% read in pics and do some stats on the colorchannel
% this one (sincitypics2) restricts the replacing to one side of the
% picture

for x = 1:size(filemat,1); % loop over files; 

 %find basename

dotindex = findstr(deblank(filemat(x,:)), '.'); 

basename = deblank(filemat(x,1:dotindex-1)); 

% read files and create basic matrices
    
a = imread(deblank(filemat(x,:)));

% take care of the right half for later
z = a(:,size(a,2)/2+1:size(a,2),:); 

z2 = rgb2gray(z); 

z3 = z;  z3(:,:,1) = z2; z3(:,:,2) = z2; z3(:,:,3) = z2; 

% basic matrices for the left half

a = a(:,1:size(a,2)/2,:); 

figure(1), subplot(2,2,1), imshow(a)

size(a), disp(filemat(x,:))

b = rgb2gray(a); 

c = a;  c(:,:,1) = b; c(:,:,2) = b; c(:,:,3) = b; 

imdata_red = a(:,:,1); imdata_green = a(:,:,2); imdata_blue=a(:,:,3); 

% start with color red

color = 'red';
    
    % find top pixelpercentage % red pixels that are also small for b and g at
    % the same time
    
    tempmat = double(a); % this is critical or there will not be any values < 0 :-) 
    tempmat(:,:,1) = tempmat(:,:,1)-255;   % set the 3d coordinate origin at full red and nothing b and g 
    
    distmat = sqrt(tempmat(:, :, 1).^2 + tempmat(:, :, 2).^2+ tempmat(:, :, 3).^2); 
            
        histdist = reshape(distmat, 1,size(b,1)*size(b,2)); 
        
       [values, bin] =  hist(histdist, 100); 
       
       subplot(2,2,2), bar(bin, values); 
       
       % find pixelpercentage cutoff
       cumvals = cumsum(values);
      
       critvalindex = find(cumvals> (size(b,1)*size(b,2)*pixelpercentage));  % (size(b,1)*size(b,2)*pixelpercentage)
       
       highredindex = find(distmat < bin(critvalindex(1)));  
    
     % writing red to the indices into the grayscale version of each layer
    
    imdata_red = b; imdata_green = b; imdata_blue=b; 
    
    imdata_red(highredindex) = 255; 
    imdata_green(highredindex) = 0; 
    imdata_blue(highredindex) = 0; 
    
    I2 = c; 
    I2(:,:,1) = imdata_red; I2(:,:,2) = imdata_green;  I2(:,:,3) = imdata_blue;  
    I2both = cat(2, I2, z3);
    
    subplot(2,2,3), imshow(I2both), 
 
     
 % write result to file
  imwrite(I2both,[basename 'L.' color '.jpg' ], 'jpg')
    
    
color = 'green'; 
     
    % writing green to the indices into the grayscale version of each layer
    
    imdata_red = b; imdata_green = b; imdata_blue=b; 
    
    imdata_red(highredindex) = 0; 
    imdata_green(highredindex) = 255; 
    imdata_blue(highredindex) = 0; 
    
    I3 = c; 
    I3(:,:,1) = imdata_red; I3(:,:,2) = imdata_green;  I3(:,:,3) = imdata_blue;  
    
    I3both = cat(2,I3, z3); 
    
    subplot(2,2,4), imshow(I3both), 
    pause(1)
    
      imwrite(I3both,[basename 'L.' color '.jpg' ], 'jpg')
   
end



end
    
    
    
    
    
    




