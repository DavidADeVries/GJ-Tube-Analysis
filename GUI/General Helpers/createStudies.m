function [studies, patientId] = createStudies(folderPath)
% [studies, patientId] = createStudies(folderPath)
% creates a list of studies based upon the path given. Each directory at
% the path given will be considered a study, each containing directories of
% studies, which in turn contain .dcm (DICOM) files
% also returns the patientId of the DICOM files
    dirList = dir(folderPath);
    studies = Study.empty;

    numStudies = 0;
    
    patientId = '';

    for i=1:length(dirList)
        entry = dirList(i);
        name = entry.name;

        if entry.isdir && ~(strcmp(name, '..') || strcmp(name, '.'))
            numStudies = numStudies + 1;

            [series, patientId] = createSeries(strcat(folderPath,'/', name), patientId); 

            studies(numStudies) = Study(name, series);
        end
    end
end

function [series, patientId] = createSeries(folderPath, patientId)
    dirList = dir(folderPath);
    
    series = Series.empty;
    numSeries = 0;
    
    for i=1:length(dirList)
        entry = dirList(i);
        name = entry.name;
        
        if entry.isdir && ~(strcmp(name, '..') || strcmp(name, '.'))
            numSeries = numSeries + 1;
            
            [files, patientId] = createFiles(strcat(folderPath,'/', name), patientId);
            
            series(numSeries) = Series(name, files);
        end
    end
end

function [files, patientId] = createFiles(folderPath, patientId)
    dirList = dir(folderPath);
    
    files = File.empty;
    numFiles = 0;
    
    for i=1:length(dirList)
        entry = dirList(i);
        name = entry.name;
        
        if ~entry.isdir %must be file!
            len = length(name);
            fileType = name(len-2:len);
            
            if strcmp(fileType, 'dcm'); %make sure it's a dicom
                completeFilepath = strcat(folderPath,'/', name);
                dicomImage = dicomread(completeFilepath);
                
                if (length(size(dicomImage)) == 2)
                    dicomInfo = dicominfo(completeFilepath);
                    
                    newPatientId = dicomInfo.PatientID;
                    
                    if isempty(patientId)
                        patientId = newPatientId;
                    end
                    
                    if strcmp(patientId, newPatientId) %verify all the files are from the same patient
                        originalLimits = [min(min(dicomImage)), max(max(dicomImage))];                    
                    
                        numFiles = numFiles + 1;
                    
                        files(numFiles) = File(name, dicomInfo, dicomImage, originalLimits);
                    else
                        patientIdConflictDialog(patientId, newPatientId, completeFilepath);
                    end
                end
            end
        end
    end
end