function [ ] = exportPatients(patients)
%[ ] = exportPatients(patients) interacts with the user to handle the
%exporting of the patient list given

[cancelled, overwrite] = overwriteOrAppendDialog(); %user can choose to overwrite file or append to it

if ~cancelled
    path = strcat(Constants.HOME_DIRECTORY, '*.csv');
    
    fileOptions = {'*.csv','Comma Delimited Spreadsheets (*.csv)'};
    popupTitle = 'Export Analysis Data';
    
    if overwrite
        [exportFilename, exportPathname] = uiputfile(path, popupTitle);
    else %append
        [exportFilename, exportPathname, ~] = uigetfile(fileOptions, popupTitle, path);
    end
    
    exportPath = strcat(exportPathname, exportFilename);
    
    if ~isempty(exportPath) %didn't click cancel
        exportToCsv(patients, exportPath, overwrite);
        
        waitfor(exportCompleteDialog());
    end
    
end

end
