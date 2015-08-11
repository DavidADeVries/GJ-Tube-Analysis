function [ handles ] = deleteImage( handles )
%[ handles ] = deleteImage( handles )
%   deletes the image that is currently being shown. Sets handle to empty.

imageHandle = handles.imageHandle;

if ~isempty(imageHandle)
    delete(imageHandle);
end

handles.imageHandle = gobjects(0);


end

