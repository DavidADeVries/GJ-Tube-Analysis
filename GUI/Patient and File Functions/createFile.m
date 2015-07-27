function [ file ] = createFile(imageFilename, dicomInfo, imagePath, image )
%[ file ] = createFile(iamgeFilename, dicomInfo, dicomImage )
%   As required by GIANT

originalLimits = [min(min(image)), max(max(image))]; %saves contrast state

file = GasSamFile(imageFilename, dicomInfo, imagePath, originalLimits);


end

