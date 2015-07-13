classdef GasSamPatient < Patient
    %Patient a patient contains a list of (DICOM) Files, in order from
    %earliest to latest
    
    properties
        longitudinalFileNumbers = []; %all file numbers valid for longitudinal compare. On/off is set in File.
        longitudinalOn = false;
    end
    
    methods
        %% Constructor %%
        function gasSamPatient = GasSamPatient(patientId, studies)
            gasSamPatient@Patient(patientId, studies);
        end
               
        
        %% updateLongitudinalFileNumber %%
        function patient = updateLongitudinalFileNumbers(patient) % checks file list to see if any others should be added on as an option, or if any should be removed (if they're no longer valid: no tube, no metric points, etc)
            patientFiles = patient.files;
            fileNumbersCounter = 1;
            
            fileNumbers = [];
            
            for i=1:length(patientFiles)
                if patientFiles(i).isValidForLongitudinal()
                    fileNumbers(fileNumbersCounter) = i;
                    fileNumbersCounter = fileNumbersCounter + 1;
                end
            end
            
            patient.longitudinalFileNumbers = fileNumbers;
        end
        
        %% getLonditudinalDisplayFileNumbers %%
        function displayFileNumbers = getLongitudinalDisplayFileNumbers(patient) %gives the file numbers from the longitudinalFileNumber list that have their display option on
            allFileNumbers = patient.longitudinalFileNumbers;
            
            allFileCounter = 1;
            
            displayFileNumbers = [];
            
            for i=1:length(allFileNumbers)
                if patient.files(allFileNumbers(i)).longitudinalOverlayOn
                    displayFileNumbers(allFileCounter) = allFileNumbers(i);
                    allFileCounter = allFileCounter + 1;
                end
            end
        end
        
        %% getLongitudinalListboxData %%
        function [ labels, values ] = getLongitudinalListboxData(patient)
            %getLongitudinalListboxData returns the labels for the listbox as well as
            %which are selected
            
            valuesCounter = 1;
            
            longitudinalFileNums = patient.longitudinalFileNumbers;
            patientFiles = patient.files;
            
            for i=1:length(longitudinalFileNums)
                if patientFiles(longitudinalFileNums(i)).longitudinalOverlayOn
                    values(valuesCounter) = i;
                    valuesCounter = valuesCounter + 1;
                end
                
                labels{i} = patientFiles(longitudinalFileNums(i)).date.display(); %labels are date of image
            end           
        end
               
       
    end
    
end

