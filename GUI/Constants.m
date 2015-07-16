classdef Constants
    %Constants stores the constants
    
    properties (Constant = true)
        % for dev
        GIANT_PATH = '/data/projects/General Image Analysis Toolkit/metadata/';
        
        % for released
        %GIANT_PATH = '/data/projects/General Image Analysis Toolkit/Current Release/';
        
        
        
        
        SAVED_PATIENTS_DIRECTORY = '/data/projects/GJ Tube/GJ Tube Study/Saved Patient Analysis/'; %make sure it's absolute and ends with '/'
        RAW_DATA_DIRECTORY = '/data/projects/GJ Tube/GJ Tube Study/Raw Data/';
        CSV_EXPORT_DIRECTORY = '/data/projects/GJ Tube/GJ Tube Study/Exported Spreadsheets/';
        
        SAVE_TITLE_SUGGESTION = 'Tube Analysis';
        
        TUBE_POINT_RESOLUTION = 25;
        
        TEXT_LABEL_BORDER_WIDTH = 1;
        DISPLAY_LINE_BORDER_WIDTH = 1;
        
        METRIC_LINE_LABEL_BORDER_COLOUR = [0 0 0] / 255; %black
        METRIC_LINE_LABEL_TEXT_COLOUR = [0 255 0] / 255; %lime green
        METRIC_LINE_LABEL_FONT_SIZE = 20;
        
        METRIC_LINE_WIDTH = 3;
        METRIC_LINE_ARROW_ENDS = 'both';
        METRIC_LINE_COLOUR = [0 255 0] / 255; %lime green
        METRIC_LINE_BORDER_COLOUR = [0 0 0] / 255; %black
        
        METRIC_LINE_BRIDGE_COLOUR = [153 255 153] / 255; %a bit more subdued then the metric lines
        METRIC_LINE_BRIDGE_ARROW_ENDS = 'none'; %just a line
        
        METRIC_POINT_COLOUR = [255,255,0] / 255; %yellow
        METRIC_POINT_LABEL_BORDER_COLOUR = [0 0 0] / 255; %black
        METRIC_POINT_LABEL_TEXT_COLOUR = [255, 255, 0] / 255; %yellow
        METRIC_POINT_LABEL_FONT_SIZE = 20;
        
        WAYPOINT_COLOUR = 'c'; %cyan
        
        TUBE_STYLE = 'line'; %options: 'points' or 'line'
        TUBE_BORDER_COLOUR = [0 0 0]/255; %black
        TUBE_BORDER_WIDTH = 1;
        TUBE_WIDTH = 5;
        TUBE_BASE_COLOUR = [0 0.5 1]; %bluish
        
        REFERENCE_LINE_COLOUR = [0, 204, 153]/255; %teal/green
        
        MIDLINE_COLOUR = 'r'; %red
        
        QUICK_MEASURE_LINE_COLOUR = [255, 153, 51] / 255; %brownish-orange
        QUICK_MEASURE_LABEL_BORDER_COLOUR = [0 0 0] / 255; %black
        QUICK_MEASURE_LABEL_TEXT_COLOUR = [255, 153, 51] / 255; %brownish-orange
        QUICK_MEASURE_LABEL_FONT_SIZE = 20;
        
        LONGITUDINAL_START_COLOUR = [0 127 255] / 255; %blue
        LONGITUDINAL_END_COLOUR = [153 51 255] / 255; %purple
                
        DELTA_LINE_LABEL_BORDER_COLOUR = [0 0 0] / 255; %black
        DELTA_LINE_LABEL_TEXT_COLOUR = [255, 103, 0] / 255; %orange
        DELTA_LINE_LABEL_FONT_SIZE = 20;
        
        DELTA_LINE_BORDER_COLOUR = [0 0 0] /255; %black
        DELTA_LINE_WIDTH = 3;
        DELTA_LINE_COLOUR = [255, 103, 0] / 255; %orange
        DELTA_LINE_ARROW_ENDS = 'stop';     
        
        TUNING_POINT_SPACING = 10;
        TUNING_POINT_START_COLOUR = [0.5 0 0];
        TUNING_POINT_END_COLOUR = [1 0.5 0];
    end
    
    methods
    end
    
end

