function [ ] = updateStudySelector( handles )
%[ ] = updateStudySelector( currentPatient, handles )
% updates the studySelector listbox

currentPatient = getCurrentPatient(handles);

if isempty(currentPatient)
    studies = Study.empty;
else
    studies = currentPatient.studies;
end

numStudies = length(studies);

if numStudies == 0 %if patient has no studies
    set(handles.studySelector, 'String', {'No Studies Available'}, 'Value', 1, 'Enable', 'off');
else
    selectorOptions = cell(numStudies,1);
    
    for i=1:numStudies
        selectorOptions{i} = studies(i).name;
    end
    
    set(handles.studySelector, 'String', selectorOptions, 'Value', currentPatient.currentStudyNum, 'Enable', 'on');
end


end

