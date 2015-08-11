function handles = deleteAll(handles)
% handles = deleteAll(handles);
% deletes all possible drawn objects, and wipes their handles clean

handles = deleteImage(handles);

handles = deleteTube(handles);
handles = deleteWaypoints(handles);
handles = deleteRefLine(handles);
handles = deleteMidline(handles);
handles = deleteMetricLines(handles);
handles = deleteMetricPoints(handles);
handles = deleteQuickMeasure(handles);
handles = deleteLongitudinalComparison(handles);


end

