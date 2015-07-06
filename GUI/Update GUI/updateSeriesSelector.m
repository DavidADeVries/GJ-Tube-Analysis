function [ ] = updateSeriesSelector(handles )
%[ ] = updateSeriesSelector( currentPatient, handles )
% updates the seriesSelector listbox

currentPatient = getCurrentPatient(handles);

if isempty(currentPatient)
    series = Series.empty;
else
    series = currentPatient.getAllSeriesForCurrentStudy();
end

numSeries = length(series);

if numSeries == 0 %if patient has no studies
    set(handles.seriesSelector, 'String', {'No Series Available'}, 'Value', 1, 'Enable', 'off');
else
    selectorOptions = cell(numSeries,1);
    
    for i=1:numSeries
        selectorOptions{i} = series(i).name;
    end
    
    set(handles.seriesSelector, 'String', selectorOptions, 'Value', currentPatient.getCurrentSeriesNum(), 'Enable', 'on');
end


end

