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
    filename = file.name;
    
    modality = file.dicomInfo.Modality;
    date = file.date.display();
    
    currentPatient = getCurrentPatient(handles);
    sequenceNumber = strcat(num2str(currentPatient.getCurrentFileNumInSeries()), '/', num2str(currentPatient.getNumFilesInSeries()));
    
    seriesDescription = file.getSeriesDescription();
    studyDescription = file.getStudyDescription();
end

set(handles.imageSequenceNumber, 'String', sequenceNumber);

set(handles.filename, 'String', filename);
set(handles.modality, 'String', modality);
set(handles.studyDate, 'String', date);
set(handles.seriesDescription, 'String', seriesDescription);
set(handles.studyDescription, 'String', studyDescription);


end

