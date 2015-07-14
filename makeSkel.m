function [ skelImage ] = makeSkel( image, blackOnWhite )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

params = struct('FrangiScaleRatio',1,'BlackWhite',blackOnWhite);

[j,~,~] = FrangiFilter2D(image, params);

jbw = im2bw(j, graythresh(j));

deblob = bwareaopen(jbw,1000);

skel = bwmorph(deblob,'skel',Inf);

despur = bwmorph(skel,'spur',50);

l


skelImage = despur;


end

