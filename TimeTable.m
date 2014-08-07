classdef TimeTable < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess=private)
        eventTable =[];
        
        %can be a vector (1xn - cell array)
        %can be a 2d cell array - where rows are randomized - not yet
        %decided on way to solve this
    end
    
    methods
        %constructor function - pass a cell array to the constructor :
        % {250,[100,400,800],-1}
        function obj = TimeTable(eventTable)
            try
                obj.eventTable = eventTable;
            catch
                disp('empty time table object');
            end
        end
        
        % Time Table usage:
        % 1. val >= 0 - will be handled as ms to wait after drawing
        % the frame on-screen
        % 2. -1 - await a keypress from the keyTable
        %
        
        %display
        function disp(obj)
            disp('Time Table:');
            disp('-----------');
            disp('Times:');
            
            for i=1:size(obj.eventTable,2)
                if(obj.eventTable{i} >0)
                    disp([i, obj.eventTable(i)]);
                else
                    sprintf('%i await keypress',i);
                end
            end;
            disp('-----------');
        end
        
        %get the eventTable
        function times = getEventTable(obj)
            times = obj.eventTable;
        end
        
        function addTiming(obj,time,varargin)
            %we will work with cells
            %value larger than or equal to 0 - time to wait until next trialframe
            %value smaller than 0 - wait for keypress
           
                if size(varargin,2) > 1 % in between x and x+1 - insert time in between values
                    obj.eventTable = insertCell(obj.eventTable,time,varargin{1});
                else
                    %simply add the column vector (from 1x1 to nx1) 
                    %tbd : special distribution vector addition
                    obj.eventTable{end+1} = time;
                end
        
            
            %internal function used for the insertion and shifting
            function c = insertCell(c,ins,idx)
                c = [c(1:idx-1) {ins} c(idx:end)];
            end
        end
        
    end
end


