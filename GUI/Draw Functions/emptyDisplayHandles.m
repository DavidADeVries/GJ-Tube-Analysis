function [ handles ] = emptyDisplayHandles( handles )
%[ handles ] = emptyDisplayHandles( handles )
% sets all display object handles to be empty
% useful when an imshow clears everything, but you still have the handles
% for objects lying around

handles.imageHandle = gobjects(0);

handles.waypointHandles = impoint.empty;
handles.displayTube = DisplayTube.empty;
handles.metricLineTextLabels = TextLabel.empty;
handles.metricLineDisplayLines = DisplayLine.empty;
handles.metricPointHandles = impoint.empty;
handles.metricPointTextLabels = TextLabel.empty;
handles.refLineHandle = imline.empty;
handles.midlineHandle = imline.empty;
handles.quickMeasureLineHandle = imline.empty;
handles.quickMeasureTextLabel = TextLabel.empty;
handles.tubePointHandles = impoint.empty;

handles.longitudinalDisplayTubes = LongitudinalDisplayTube.empty;
handles.deltaLineTextLabels = TextLabel.empty;
handles.deltaLineDisplayLines = DisplayLine.empty;

end

