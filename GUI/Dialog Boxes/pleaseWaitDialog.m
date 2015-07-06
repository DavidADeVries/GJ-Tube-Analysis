function [ handle ] = pleaseWaitDialog(message)
% [ handle ] = pleaseWaitDialog()
% tells the user to wait for whatever

message = ['Please wait, ', message];

title = 'Please Wait...';

handle = dialog('Name',title);

position = get(handle, 'Position');

location = position(1:2);

size = [300, 100];

grey = 0.9 * [1 1 1];

set(handle, 'Position', [location, size], 'Color', grey);

uicontrol('Parent', handle, 'Position', [20, 30, 260, 40], 'BackgroundColor', grey, 'Style', 'text', 'String', message);

drawnow; %make sure it shows up.


end

