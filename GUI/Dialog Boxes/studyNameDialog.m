function [ studyName ] = studyNameDialog()
%[ studyName ] = studyNameDialog()
% prompts the user for a study name

dialogTitle = 'Enter Study Name';
prompt = 'Please enter the name of the study to be created:';
numLines = 1;

studyName = inputdlg(prompt, dialogTitle, numLines);

if isempty(studyName)
    studyName = '';
else
    studyName = studyName{1}; %get string from cell array
end

end

