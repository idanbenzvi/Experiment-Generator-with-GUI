% trial consists of stimuli objects
% tbd : duration of stimuli presentation, order of stimuli, user answer
classdef Trial < handle
    %TRIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    events
        enlargeStimuli
        
        reduceStimuli
        
        rasterFramesStimuli
    end
    
    % The following properties can be set only by class methods
    properties (SetAccess = private)
        trialFrames % the frames displayed when this trial runs - V
        
        trialFrameTextures;
        
        timeTable % the trial's time table in MSecs - V
        
        screenPointer % a pointer to a screen window buffer
        
        name % the trial's name
        
        target % the stimuli that is the correct answer in this trial
        
        targetKey % the target key the user has to press in order to get a correct answer
        
        distractor % the distractor in this trial (might be more than one)
        
        distractorKey % the incorrect key press for this trial
        
        parentBlock % the block containing this trial (currently not in use)
        
        userInputType %specify user input type
        
        ID % a unique ID used for referencing of this specific trial
    end
    
    events
        renderTrialFrames
    end
    
    methods
        %Constructor function - 3 first are mandatory, other can be set
        %later
        function obj = Trial(name,trialFrames,timeTable,screenPointer)
            %set object unique ID
            obj.ID = java.rmi.server.UID();
            
            switch nargin
                case 0
                    %                     try
                    obj.name = 'empty Trial';
                    obj.trialFrames = TrialFrame.empty(0,0);
                    %                     catch
                    disp('Empty Trial created');
                    %                     end
                case 1
                    % just the trial name, frame addition will be done
                    % later
                    obj.name = name;
                    
                case 2
                    % a trial and its trialframes(textures)
                    obj.name = name;
                    obj.trialFrames = trialFrames;
                    
                case 3
                    obj.name = name;
                    obj.trialFrames = trialFrames;
                    obj.timeTable = timeTable;
                case 4
                    obj.name = name;
                    obj.trialFrames = trialFrames;
                    obj.timeTable = timeTable;
                    
                    obj.screenPointer = screenPointer;
                    
                    obj.rasterStimuli;
                    %screenPointer was given - notify / address all
                    %trialframes and render them (if not already rendered)
                    %                     obj.trialFrames
            end
        end
        
        function addTrialFrame(obj,trialFrame)
            disp(['added the trialFrame ',trialFrame.name,' to trial ',obj.name]);
            obj.trialFrames(end+1) = trialFrame;
        end
        
        function addTimeTable(obj,timeTable)
            disp(['added a timetable to the trial ',obj.name]);
            obj.timeTable = timeTable;
        end
        
        function rasterStimuli(obj)
            %use events and notifiers
            %notify(obj,'renderTrialFrames');
            
            for i=1 : size(obj.trialFrames,2)
                obj.trialFrames(i).assignScreenPtr(obj.screenPointer);
            end
            
        end
        
        function setScreenPointer(obj,screenPtr)
            obj.screenPointer =  screenPtr;
            obj.rasterStimuli;
        end
        
        %         function drawPreview(obj)
        %             %non usable right now
        %             %should be converted to a real trial animation sequence
        %             for i=1:size(obj.trialFrames,2)
        %                 % display the wait time for this frame (or keypresses)
        %                 Screen('DrawText',obj.screenPointer,obj.timeTable(i),5, 5);
        %                 %draw the frame itself
        %                 Screen('DrawTexture',obj.screenPointer,obj.trialFrames(i).drawPreview);
        %             end
        %         end
        
        function disp(obj)
            disp('-----------');
            disp(obj.name);
            disp(obj.trialFrames);
            disp(obj.timeTable);
            disp('---end of Trial---');
        end
        
        function childList = getChildren(obj)
            for  i=1:size(trialFrames,2)
                childList(i) = obj.trialFrames{i}.name;
            end
        end
        
        function set.target(obj,target)
            
        end
        
        function set.distractor(obj,distractor)
            
        end
        
        function set.targetKey(obj,key)
            
        end
        
        function trialFrameTextures = getTextures(obj)
            for i=1: numel(obj.trialFrames)
                trialFrameTextures(i) = obj.trialFrames(i).texture;
            end
        end
        
        function numOfFrames = frameNum(obj)
            numOfFrames = size(obj.trialFrames,2);
        end
        
        function timeTable = getTimeTable(obj)
            timeTable = obj.timeTable.getEventTable;
        end
        
        function setTimeTable(obj,timeTable)
            obj.timeTable = timeTable;
        end
        
        function ID = getID(obj)
            ID = obj.ID;
        end
        
        %generate a structure containing all the trail properties
        function cl_out = getPropertyStrcuture(obj)
            cl_out = getObjectProperties(obj);
        end
    end
    
end
