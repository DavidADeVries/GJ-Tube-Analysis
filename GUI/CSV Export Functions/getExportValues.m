function values = getExportValues(patient, study, series, file, sequenceNumber)
% values = getExportValues(patient, study, series, file, sequenceNumber)
% uses the patient, study, series, and file to determine what to print in
% each cell for a row for the csv export
% required by GIANT

measurements = file.getMeasurements();

values = struct(...
    'patientId', patient.patientId,...
    'patientSex', file.dicomInfo.PatientSex,...
    'patientDob', '',... %will be manually entered into .csv
    'sequenceNumber', sequenceNumber,...
    'studyDate', file.date.stringForCsv(),...
    'modality', file.dicomInfo.Modality,...
    'studyName', study.name,...
    'seriesName', series.name,...
    'fileName', file.name,...
    'measurementA', measurements.a,...
    'measurementB', measurements.b,...
    'measurementC', measurements.c,...
    'measurementD', measurements.d,...
    'measurementE', measurements.e,...
    'measurementF', measurements.f,...
    'measurementG', measurements.g,...
    'measurementH', measurements.h,...
    'measurementI', measurements.i,...
    'measurementJ', measurements.j);

end