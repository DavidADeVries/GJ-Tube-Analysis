classdef Series
    %Series
    % a study contains one or more files
    % it usually corresponds to a visit of the patient
    % e.g. a patient will come in for an MRI study consisting of multiple
    % series (T1, T2, etc), each of which has multiple files
    
    properties
        name = ''
        
        files = File.empty;
        currentFileNum = 0;
        
    end
    
    methods
        %% Constructor %%
        function series = Series(name, files)
            series.name = name;
            series.files = files;
            
            if ~isempty(series)
                series.currentFileNum = 1;
            end
        end
        
        %% numFiles %%
        function num = numFiles(series)
            num = length(series.files);
        end
        
        %% getCurrentFile %%
        function file = getCurrentFile(series)
            if series.numFiles() >= series.currentFileNum && series.currentFileNum > 0
                file = series.files(series.currentFileNum);
            else
                file = File.empty;
            end
        end
        
        %% addFile %%
        function series = addFile(series, newFile)
            % keeps files in order by date
            oldFiles = series.files;
            numOldFiles = length(oldFiles);            
            
            i = 1; %needs to be defined before hand, in case numOldFiles = 0;
            
            while i <= numOldFiles
                if newFile.date < oldFiles(i).date
                    break;
                end
                
                i = i+1;
            end
                      
            if i == 1
                newFiles = [newFile, oldFiles];                     
                series.currentFileNum = 1;
            elseif i == numOldFiles
                newFiles = [oldFiles, newFile];                                 
                series.currentFileNum = numOldFiles+1;
            else            
                newFiles = [oldFiles(1:i-1), newFile, oldFiles(i:numOldFiles)];
                series.currentFileNum = i;
            end
                        
            series.files = newFiles;   
        end
        
        %% removeCurrentFile %%
        function series = removeCurrentFile(series)
            localFiles = series.files;
            
            localFiles(series.currentFileNum) = []; %remove
            
            series.files = localFiles;
            
            numberFiles = series.numFiles();
            
            if series.currentFileNum > numberFiles %currentFileNum stays the same unless bottom file is removed
                series.currentFileNum = numberFiles;
            end   
        end
        
        %% updateFile %%
        function series = updateFile(series, file, varargin)
            if length(varargin) == 1 %fileNum is specified
                fileNum = varargin{1};
            else
                fileNum = series.currentFileNum;
            end
            
            if series.numFiles() >= fileNum && fileNum > 0
                series.files(fileNum) = file;
            end
        end
        
        %% earlierImage %%
        function series = earlierImage(series)
            fileNum = series.currentFileNum();
            
            fileNum = fileNum - 1;
            
            if fileNum < 1
                fileNum = 1; %stop at earliest image
            end
            
            series.currentFileNum = fileNum;
        end
        
        %% laterImage %%
        function series = laterImage(series)
            fileNum = series.currentFileNum();
            
            fileNum = fileNum + 1;
            
            lastFileNum = numFiles(series);
            
            if fileNum > lastFileNum
                fileNum = lastFileNum; %stop at latest image
            end
            
            series.currentFileNum = fileNum;
        end
        
        %% earliestImage %%
        function series = earliestImage(series)
            series.currentFileNum = 1; %earliest image
        end
        
        %% latestImage %%
        function series = latestImage(series)
            series.currentFileNum = numFiles(series); %latest image
        end
    end
    
end

