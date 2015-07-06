function [] = dicomDownloadCleanup(downloadPath)
dirList = dir(downloadPath);

patientFolder = '';

if length(dirList) == 3
    for i=1:length(dirList)
        entry = dirList(i);
        name = entry.name;
        
        if entry.isdir && ~(strcmp(name, '..') || strcmp(name, '.'))
            patientFolder = name;
        end
    end
    
    patientName = createStudies(strcat(downloadPath, '/', patientFolder));
    
    oldName = strcat(downloadPath, '/', patientFolder);
    newName = strcat(downloadPath, '/', cleanString(patientName));
    
    if ~strcmp(oldName, newName)
        movefile(oldName, newName);
    end
else
    warning('Imcompatible Folder! Should only contain a single patient!');
end
end

function patientName = createStudies(patientPath)
% [studies, patientId] = createStudies(folderPath)
% creates a list of studies based upon the path given. Each directory at
% the path given will be considered a study, each containing directories of
% studies, which in turn contain .dcm (DICOM) files
% also returns the patientId of the DICOM files
dirList = dir(patientPath);

patientName = '';

studyCounter = 1;

for i=1:length(dirList)
    entry = dirList(i);
    studyFolder = entry.name;
    
    if entry.isdir && ~(strcmp(studyFolder, '..') || strcmp(studyFolder, '.'))
        
        [patientName, studyDescription, studyTime] = createSeries(strcat(patientPath,'/', studyFolder), patientName);
        
        if ~(isempty(studyDescription) || isempty(studyTime))
            studies(studyCounter) = struct('folder', studyFolder, 'studyDescription', studyDescription, 'studyTime', studyTime, 'sort', todatenum(studyTime));
            studyCounter = studyCounter + 1;
        end
    end
end

%sort studies struct array so that they can be renamed in order
studiesCell = struct2cell(studies);
dims = size(studiesCell);

studiesCell = reshape(studiesCell, dims(1), [])';
sortedStudiesCell = sortrows(studiesCell, 4); %sort on date, column 3

sortedStudiesCell = reshape(sortedStudiesCell', dims);

sortedStudies = cell2struct(sortedStudiesCell, fieldnames(studies), 1);

for i=1:length(sortedStudies)
    study = sortedStudies(i);
    
    oldName = strcat(patientPath, '/', study.folder);
    newName = strcat(patientPath, '/', padWithZeros(i, 3), '-', cleanString(study.studyDescription));
    
    if ~strcmp(oldName, newName)
        movefile(oldName, newName);
    end
end

end

function [patientName, studyDescription, studyTime] = createSeries(studyPath, patientName)
dirList = dir(studyPath);

studyDescription = '';
studyTime = '';

for i=1:length(dirList)
    entry = dirList(i);
    seriesFolder = entry.name;
    
    if entry.isdir && ~(strcmp(seriesFolder, '..') || strcmp(seriesFolder, '.'))
        [patientName, studyDescription, studyTime, seriesNumber, seriesDescription] = createFiles(strcat(studyPath,'/', seriesFolder), patientName, studyDescription, studyTime);
        
        oldName = strcat(studyPath, '/', seriesFolder);
        newName = strcat(studyPath, '/', padWithZeros(seriesNumber, 4), '-', cleanString(seriesDescription));
        
        if ~strcmp(oldName, newName)
            movefile(oldName, newName);
        end
    end
end
end

function [patientName, studyDescription, studyTime, seriesNumber, seriesDescription] = createFiles(seriesPath, patientName, studyDescription, studyTime)
dirList = dir(seriesPath);

seriesDescription = '';
seriesNumber = 0;

for i=1:length(dirList)
    entry = dirList(i);
    fileName = entry.name;
    
    if ~entry.isdir %must be file!
        len = length(fileName);
        fileType = fileName(len-2:len);
        
        if strcmp(fileType, 'dcm'); %make sure it's a dicom
            dicomHeader = dicominfo(strcat(seriesPath,'/', fileName));
            
            if isempty(patientName)
                patientName = dicomHeader.PatientName.FamilyName;
            end
            
            if isempty(studyDescription)
                studyDescription = dicomHeader.StudyDescription;
            end
            
            if isempty(studyTime)
                studyTime = dateAndTimeToEpoch(dicomHeader.StudyDate, dicomHeader.StudyTime);
            end
            
            if isfield(dicomHeader, 'SeriesDescription')
                dicomSeriesDescription = dicomHeader.SeriesDescription;
            else
                dicomSeriesDescription = dicomHeader.SeriesInstanceUID;
            end
            
            
            if isempty(seriesDescription)
                seriesDescription = dicomSeriesDescription;
            end
            
            if seriesNumber == 0
                seriesNumber = dicomHeader.SeriesNumber;
            end
            
            if ~(strcmp(patientName, dicomHeader.PatientName.FamilyName))
                warning('PatientName mismatch!');
            end
            
            if ~(strcmp(studyDescription, dicomHeader.StudyDescription))
                %warning('StudyDescription mismatch!');
            end
            
            if ~(strcmp(studyTime, dicomHeader.StudyTime))
                %warning('StudyTime mismatch!');
            end
            
            if ~(strcmp(seriesDescription, dicomSeriesDescription))
                %warning('SeriesDescription mismatch!');
            end
            
            if seriesNumber ~= dicomHeader.SeriesNumber
                %warning('SeriesNumber mismatch!');
            end
            
            instanceNumber = padWithZeros(dicomHeader.InstanceNumber, 4);
            
            oldName = strcat(seriesPath, '/', fileName);
            newName = strcat(seriesPath, '/', instanceNumber, '.dcm');
            
            if ~strcmp(oldName, newName)
                movefile(oldName, newName);
            end
            
            %scrubDicomFile(newName);
        else
            warning('All files must be of DICOM format!');
        end
    elseif ~(strcmp(fileName, '..') || strcmp(fileName, '.'))
        warning(['Directory found when expecting DICOMs at: ', seriesPath]);
    end
end
end

function str = cleanString(str)
    str = strrep(str, '/', '-');
    str = strrep(str, '\', '-');
end

function str = padWithZeros(num, targetLength)
    baseStr = num2str(num);
    
    len = length(baseStr);
    
    if len <= targetLength
        prefix = '';
        
        for i=len:targetLength-1
            prefix = [prefix, '0'];
        end
        
        str = [prefix, baseStr];
    else
        warning([baseStr, ' is too long for a target length of ', num2str(targetLength)]);
        
        str = baseStr(1:targetLength);
    end
end

function epoch = dateAndTimeToEpoch(dateString, timeString)
    yearString = dateString(1:4);
    monthString = dateString(5:6);
    dayString = dateString(7:8);
    
    if isempty(timeString)
        hourString = '0';
        minuteString = '00';    
    elseif mod(length(timeString), 2) == 0 %even length, hour is double digit
        hourString = timeString(1:2);
        minuteString = timeString(3:4);
    else %odd length, hour is single digit
        hourString = timeString(1);
        minuteString = timeString(2:3);
    end

    dateString = datestr([str2num(yearString), str2num(monthString), str2num(dayString), str2num(hourString), str2num(minuteString), 0]);
    epoch = cdfepoch(dateString);
end

function [] = scrubDicomFile(filepath)
    image = dicomread(filepath);
    dicomHeader = dicominfo(filepath);
    
    patientName = dicomHeader.PatientName.FamilyName;
    
    newHeader = dicomHeader;
    newHeader.PatientID = patientName;
    
    newHeader = struct('PatientID', patientName);
    
    try
        dicomanon(filepath, filepath, 'update', newHeader);
    catch
        message = ['There was an error in the DICOM for the file with Study Description: "', dicomHeader.StudyDescription, '", Study Date: "', dicomHeader.StudyDate, '", and Study Time: "', dicomHeader.StudyTime, '". The header could not be scrubbed of all identifying information and so the file was deleted'];
        warning(message);
    end
end