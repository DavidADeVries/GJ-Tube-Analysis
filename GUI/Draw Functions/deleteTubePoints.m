function [ handles ] = deleteTubePoints( handles )
%deleteTubePoints deletes the all the handles associated with the tube points. Updates
%handles to reflect this

tubePointHandles = handles.tubePointHandles;

for i=1:length(tubePointHandles)
    delete(tubePointHandles(i));
end

handles.tubePointHandles = impoint.empty;

end

