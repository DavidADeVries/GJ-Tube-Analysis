function [ final ] = deblobber( image, minBlobSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dims = size(image);
checked = zeros(dims);
final = zeros(dims);

for i=1:dims(1)
    for j=1:dims(2)
        if ~checked(i,j) && image(i,j)
            blob = bwselect(image, j, i, 8);
            
            checked = checked + blob;
            
            if sum(sum(blob)) > minBlobSize
                final = final + blob;
            end
        end
        
    end
    
    disp(i);
end

end

