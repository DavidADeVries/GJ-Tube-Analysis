function [ ] = updatePatientSelector( handles )
%updatePatientSelector updates options for available patients to select
%from

patients = handles.patients;

numPatients = handles.numPatients;

if numPatients == 0 %if no patients are open
    set(handles.patientSelector, 'String', {'No Patient Selected'}, 'Value', 1, 'Enable', 'off');
else
    selectorOptions = cell(numPatients,1);
    
    for i=1:numPatients
        selectorOptions{i} = num2str(patients(i).patientId);
    end
    
    set(handles.patientSelector, 'String', selectorOptions, 'Value', handles.currentPatientNum, 'Enable', 'on');
end


end

