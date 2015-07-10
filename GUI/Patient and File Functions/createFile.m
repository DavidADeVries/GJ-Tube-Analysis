function [ file ] = createFile(imageFilename, dicomInfo, dicomImage )
%[ file ] = createFile(iamgeFilename, dicomInfo, dicomImage )
%   As required by GIANT

originalLimits = [min(min(dicomImage)), max(max(dicomImage))];

file = GJTubeFile(imageFilename, dicomInfo, dicomImage, originalLimits);


end

