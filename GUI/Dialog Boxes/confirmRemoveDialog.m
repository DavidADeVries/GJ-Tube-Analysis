function [ cancelled ] = confirmRemoveDialog(question, title )
%confirmRemoveDialog makes sure user really wants to remove something from
%the patient
%from the patient

cancelled = true;

remove = 'Remove';
cancel = 'Cancel';

default = remove;

choice = questdlg(question, title, remove, cancel, default);

switch choice
    case remove
        cancelled = false;
    case cancel
        cancelled = true;
end

end

