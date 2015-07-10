function [ patient ] = createPatient(patientId, studies)
%[ patient ] = createPatient(patientId, studies)
% as required by GIANT

patient = GJTubePatient(patientId, studies);

end

