function [ patient ] = emptyPatient(varargin)
%[ patient ] = emptyPatient()
% as required by GIANT

numArg = length(varargin);

if numArg == 1
    patient = GasSamPatient.empty(varargin{1});
elseif numArg == 2
    patient = GasSamPatient.empty(varargin{1}, varargin{2});
else
    patient = GasSamPatient.empty;
end

end

