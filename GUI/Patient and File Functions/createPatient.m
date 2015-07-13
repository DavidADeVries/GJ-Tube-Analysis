function [ patient ] = createPatient(patientId, studies)
%[ patient ] = createPatient(patientId, studies)
% as required by GIANT

patient = GasSamPatient(patientId, studies);

end

