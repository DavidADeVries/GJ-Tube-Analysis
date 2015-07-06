function [ seriesName ] = seriesNameDialog()
%[ seriesName ] = seriesNameDialog()
% prompts the user for a series name

dialogTitle = 'Enter Series Name';
prompt = 'Please enter the name of the series to be created:';
numLines = 1;

seriesName = inputdlg(prompt, dialogTitle, numLines);

if isempty(seriesName)
    seriesName = '';
else
    seriesName = seriesName{1}; %get string from cell array
end
    

end

