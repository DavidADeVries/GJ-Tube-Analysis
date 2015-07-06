function [ ] = updateImageInfo( file, handles)
%updateImageInfo updates the fields within the "Image Information" 

if isempty(file)
    noImage = 'No Image Selected';
    na = 'N/A';
    
    sequenceNumber = '0/0';
    
    filename = noImage;
    modality = na;
    date = na;
    
    seriesDescription = na;
    studyDescription = na;
else
    path = file.dicomInfo.Filename;
    pathComponents = strsplit(path,'/');
    numComponents = length(pathComponents);
    
    filename = '';
    
    if numComponents >= 1
        filename = pathComponents{numComponents}; %actual filename
    end
    
    if numComponents >= 2
        filename = strcat(pathComponents{numComponents-1}, '/', filename); %give one folder of context if possible
    end
    
    if numComponents >= 3
        filename = strcat(pathComponents{numComponents-2}, '/', filename); %give two folders of context if possible
    end
    
    modality = file.dicomInfo.Modality;
    date = file.date.display();
    
    currentPatient = getCurrentPatient(handles);
    sequenceNumber = strcat(num2str(currentPatient.getCurrentFileNumInSeries()), '/', num2str(currentPatient.getNumFilesInSeries()));
    
    seriesDescription = file.getSeriesDescription();
    studyDescription = file.getStudyDescription();
end

set(handles.imageSequenceNumber, 'String', sequenceNumber);

set(handles.imageFilename, 'String', filename);
set(handles.modality, 'String', modality);
set(handles.studyDate, 'String', date);
set(handles.seriesDescription, 'String', seriesDescription);
set(handles.studyDescription, 'String', studyDescription);


end

