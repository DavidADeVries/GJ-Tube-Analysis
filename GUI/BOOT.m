function [ ] = BOOT( constantsDirectory )
% BOOT( constantsDirectory ) 
% this function boots up the module, loading all the necessary
% libraries. The path to the study's constants file (e.g. '../../Test
% Study/Code Files') must be given to BOOT to give it the context it will
% be running in.

% add needed librarys

addpath('../Vesselness Enhancement');
addpath('../arrow');
addpath('../MATLAB Image Functions');
addpath('../Peter Kovesi Computer Vision Libraries/Feature Detection');

addpath(genpath('.')); %add all subfolders in the current directory

% add in constant files that are specific to each study
addpath(constantsDirectory);

addpath(genpath(strcat(Constants.GIANT_PATH, 'GIANT Code')));

addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Quick Measure'));
addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Plot Impoint'));
addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Line Labels'));
addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Classes'));

% Boot the GUI

GAS_SAM();

end

