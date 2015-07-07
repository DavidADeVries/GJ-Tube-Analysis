function [ ] = exportToCsv(patients, exportPath, overwrite)
%exportToCsv exports the list of patients to the given .csv path.
%'overwrite' specifies whether to overwrite the file completely, or whether
%to append. Note that when appending, only the patients in the file that
%are NOT in the list of patients are saved. If a patient in is the file and
%in the list, the one in the list takes precedent and COMPLETELY overwrites
%the existing patient data

newline = '\n';

linesToKeep = cell(0);
    
if ~overwrite
    [fileId, err] = fopen(exportPath, 'r');
    
    if isempty(err)        
        fgets(fileId); %ignore header
        line = fgets(fileId);
        
        ignoreTillNextId = false;
        
        i = 1;
        
        while(ischar(line))
            split = strsplit(strrep(line,',,',', ,'), ',');
            patientId = char(split(1));
            
            if ignoreTillNextId && ~isempty(patientId)
                ignoreTillNextId = false;
            end
            
            if ~ignoreTillNextId && isPatientIdPresent(patientId, patients) %need to be removed, do not save lines
                ignoreTillNextId = true;
            end
            
            if ~ignoreTillNextId
                patientId = char(split(1));
                patientSex = char(split(2));
                patientDob = char(split(3));
                sequenceNumber = str2num(char(split(4)));
                studyDate = char(split(5));
                % skip formula; row indices need to be reset
                modality = char(split(7));
                studyDescription = char(split(8));
                seriesDescription = char(split(9));
                measurementA = str2num(char(split(10)));
                measurementB = str2num(char(split(11)));
                measurementC = str2num(char(split(12)));
                measurementD = str2num(char(split(13)));
                measurementE = str2num(char(split(14)));
                measurementF = str2num(char(split(15)));
                measurementG = str2num(char(split(16)));
                measurementH = str2num(char(split(17)));
                measurementI = str2num(char(split(18)));
                measurementJ = str2num(char(split(19)));                
                
                linesToKeep{i} = {patientId, patientSex, patientDob, sequenceNumber, studyDate, modality, studyDescription, seriesDescription, measurementA, measurementB, measurementC, measurementD, measurementE, measurementF, measurementG, measurementH, measurementI, measurementJ};
                i = i + 1;
            end
            
            line = fgets(fileId);
        end
        
        fclose(fileId);
    else
        warning(err);
    end
end
    
[fileId, err] = fopen(exportPath, 'w');

if isempty(err) %write file anew
    %write column headers
    
    headers = { 'Patient Id',...
        'Patient Sex',...
        'Patient DOB (MMM-YY)',...
        'Sequence Number',...
        'Study Date (DD-MMM-YY)',...
        'Age at Study (months)',...
        'Modality',...
        'Study Description',...
        'Series Description',...
        'Measurement a (u)',...
        'Measurement b (u)',...
        'Measurement c (u)',...
        'Measurement d (u)',...
        'Measurement e (u)',...
        'Measurement f (u)',...
        'Measurement g (u)',...
        'Measurement h (u)',...
        'Measurement i (Curvature)',...
        'Measurement j (Curvature)'};
    
    numHeaders = length(headers);
    
    for i=1:numHeaders
        fprintf(fileId, headers{i});
        
        if i ~= numHeaders
            fprintf(fileId, ',');
        end
    end
    
    fprintf(fileId, newline);
    
    lineNumber = 2; %line 1 is the headers
    
    %write data from previous file if choosen to not overwrite
    
    for i=1:length(linesToKeep)
        printToFile(fileId, lineNumber, linesToKeep{i}, newline);
        lineNumber = lineNumber + 1;
    end
    
    %write new data from patient list
    
    for i=1:length(patients)
        patient = patients(i);
        files = patient.getAllFiles();
        
        sequenceNumber = 1;
        
        for j=1:length(files)
            file = files(j);
            
            if ~isempty(file.metricPoints) && ~isempty(file.refPoints) && ~isempty(file.midlinePoints) %these fields must be populated for analysis to be considered complete
                
                measurements = file.getMeasurements();
                
                values = {patient.patientId,...
                    file.dicomInfo.PatientSex,...
                    '',... %Date of birth
                    sequenceNumber,...
                    file.date.stringForCsv(),...
                    file.dicomInfo.Modality,...
                    file.dicomInfo.StudyDescription,...
                    file.dicomInfo.SeriesDescription,...
                    measurements.a,...
                    measurements.b,...
                    measurements.c,...
                    measurements.d,...
                    measurements.e,...
                    measurements.f,...
                    measurements.g,...
                    measurements.h,...
                    measurements.i,...
                    measurements.j};
                
                printToFile(fileId, lineNumber, values, newline);
                
                lineNumber = lineNumber + 1;
                sequenceNumber = sequenceNumber + 1;
            end
        end
    end
    
    fclose(fileId);
    
else
    warning(err);
end

end

function [bool] = isPatientIdPresent(patientId, patients)
    bool = false;
    
    i=1;
    
    while (i <= length(patients) && ~bool)
        if strcmp(patients(i).patientId, patientId)
            bool = true;
        end
        
        i = i+1;
    end
end

function [] = printToFile(fileId, lineNumber, values, newline)
    dobCell = ['C', num2str(lineNumber)];
    studyDateCell = ['E', num2str(lineNumber)];

    ageFormula = ['=(MONTH(', studyDateCell ,') - MONTH(', dobCell, '))+(YEAR(', studyDateCell, ') - YEAR(', dobCell, '))*12'];

    fprintf(fileId, '%s,%s,%s,%d,%s,%s,%s,%s,%s,%6.1f,%6.1f,%6.1f,%6.1f,%6.1f,%6.1f,%6.1f,%6.1f,%6.4f,%6.4f',...
        values{1},...
        values{2},...
        strrep(values{3},' ',''),...
        values{4},...
        values{5},...
        ageFormula,...
        values{6},...
        values{7},...
        values{8},...
        values{9},...
        values{10},...
        values{11},...
        values{12},...
        values{13},...
        values{14},...
        values{15},...
        values{16},...
        values{17},...
        values{18});

    fprintf(fileId, newline);
end
