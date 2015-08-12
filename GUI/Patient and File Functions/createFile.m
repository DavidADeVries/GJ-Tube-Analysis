function [ file ] = createFile(imageFilename, dicomInfo, imagePath, image )
%[ file ] = createFile(imageFilename, dicomInfo, imagePath, zoomLims, image )
%   As required by GIANT

originalLimits = [min(min(image)), max(max(image))]; %saves contrast state

file = GasSamFile(imageFilename, dicomInfo, imagePath, image, originalLimits);


end

