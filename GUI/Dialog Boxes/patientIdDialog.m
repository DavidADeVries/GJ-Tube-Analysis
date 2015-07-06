function [ patientId ] = patientIdDialog()
%[ patientId ] = patientIdDialog()
% prompts the user for a patient id

dialogTitle = 'Enter Patient ID';
prompt = 'Please enter the Patient ID of the patient to be created:';
numLines = 1;

patientId = inputdlg(prompt, dialogTitle, numLines);

if isempty(patientId)
    patientId = '';
else
    patientId = patientId{1}; %get string from cell array
end
    

end

