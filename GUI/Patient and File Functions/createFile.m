function [ file ] = createFile(imageFilename, dicomInfo, imagePath )
%[ file ] = createFile(iamgeFilename, dicomInfo, dicomImage )
%   As required by GIANT

file = GasSamFile(imageFilename, dicomInfo, imagePath);


end

