classdef Study
    %Study
    % a study contains one or more series
    % it usually corresponds to a visit of the patient
    % e.g. a patient will come in for an MRI study consisting of multiple
    % series (T1, T2, etc), each of which has multiple files
    
    properties
        name = '';
        
        series = Series.empty();
        currentSeriesNum = 0;
    end
    
    methods
        %% Constructor %%
        function study = Study(name, series)
            study.name = name;
            study.series = series;
            
            if ~isempty(series)
                study.currentSeriesNum = 1;
            end
        end
        
        %% numSeries %%
        function num = numSeries(study)
            num = length(study.series);
        end
        
        %% getCurrentSeries %%
        function series = getCurrentSeries(study)
            if study.numSeries() >= study.currentSeriesNum && study.currentSeriesNum > 0
                series = study.series(study.currentSeriesNum);
            else
                series = Series.empty;
            end
        end
        
        %% getCurrentFile %%
        function file = getCurrentFile(study)
           localSeries = study.getCurrentSeries();
           
           if ~isempty(localSeries)
                file = localSeries.getCurrentFile();
           else
               file = File.empty;
           end
        end
        
        %% updateFile %%
        function study = updateFile(study, file, varargin)
           localSeries = study.getCurrentSeries();
           
           if ~isempty(localSeries)
               if length(varargin) == 1
                   study.series(study.currentSeriesNum) = localSeries.updateFile(file, varargin);
               else
                   study.series(study.currentSeriesNum) = localSeries.updateFile(file);
               end
           end
        end
        
        %% addSeries %%
        function study = addSeries(study, newSeries)
            localSeries = study.series;
            
            localSeries = [localSeries, newSeries];
            
            study.series = localSeries;
            study.currentSeriesNum = numSeries(study);
        end
        
        %% removeCurrentSeries %%
        function study = removeCurrentSeries(study)
            localSeries = study.series;
            
            localSeries(study.currentSeriesNum) = []; %remove
            
            study.series = localSeries;
            
            numberStudies = study.numSeries();
            
            if study.currentSeriesNum > numberStudies %currentSeriesNum stays the same unless bottom series is removed
                study.currentSeriesNum = numberStudies;
            end   
        end
        
        %% addFile %%
        function study = addFile(study, newFile)  
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                localSeries = localSeries.addFile(newFile);
                study.series(study.currentSeriesNum) = localSeries;
            end  
        end
        
        %% removeCurrentFile %%
        function study = removeCurrentFile(study)
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                localSeries = localSeries.removeCurrentFile();
                study.series(study.currentSeriesNum) = localSeries;
            end
        end
        
         %% getNumFilesInSeries %%
        function numFiles = getNumFilesInSeries(patient)
            localSeries = patient.getCurrentSeries();
            
            if ~isempty(localSeries)
                numFiles = localSeries.numFiles();
            else
                numFiles = 0;
            end
        end
        
        %% getCurrentFileNumInSeries %%
        function fileNum = getCurrentFileNumInSeries(study)
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                fileNum = localSeries.currentFileNum;
            else
                fileNum = 0;
            end
        end
        
        %% getAllFiles %%
        function files = getAllFiles(study)
            files = File.empty;
            
            localSeries = study.series;
            
            for i=1:length(localSeries)
                files = [files, localSeries(i).files];
            end
        end
        
        %% earlierImage %%
        function study = earlierImage(study)
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                study.series(study.currentSeriesNum) = localSeries.earlierImage();
            end
        end
        
        %% laterImage %%
        function study = laterImage(study)
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                study.series(study.currentSeriesNum) = localSeries.laterImage();
            end
        end
        
        %% earliestImage %%
        function study = earliestImage(study)
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                study.series(study.currentSeriesNum) = localSeries.earliestImage();
            end
        end
        
        %% latestImage %%
        function study = latestImage(study)
            localSeries = study.getCurrentSeries();
            
            if ~isempty(localSeries)
                study.series(study.currentSeriesNum) = localSeries.latestImage();
            end
        end
    end
    
end

