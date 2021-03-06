function [ header ] = getHeader()
% [ header ] = getHeader()
% returns the header for the .csv export file as a cell array
% required by GIANT

header = {... 
        'Patient Id',...
        'Patient Sex',...
        'Patient DOB (MMM-YY)',...
        'Sequence Number',...
        'Study Date (DD-MMM-YY)',...
        'Age at Study (Months)',...
        'Modality',...
        'Study Name',...
        'Series Name',...
        'File Name',...
        'Measurement a (u)',...
        'Measurement b (u)',...
        'Measurement c (u)',...
        'Measurement d (u)',...
        'Measurement e (u)',...
        'Measurement f (u)',...
        'Measurement g (u)',...
        'Measurement h (u)',...
        'Measurement i (Curvature)',...
        'Measurement j (Curvature)',...
        'Reference Length (px)',...
        'Pylorus X (px)',...
        'Pylorus Y (px)',...
        'Point A X (px)',...
        'Point A Y (px)',...
        'Point B X (px)',...
        'Point B Y (px)',...
        'Point C X (px)',...
        'Point C Y (px)',...
        'Point D X (px)',...
        'Point D Y (px)'};

end

