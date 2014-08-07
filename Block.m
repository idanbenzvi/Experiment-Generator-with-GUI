classdef Block < handle
    %BLOCK Summary of this class goes here
    %   Detailed explanation goes here
    %CONDITION a container class that stores the following experiment data:
    %Trials,Trial TimeLines, TrialFrames(.m files)->stimuli
    % The condition class is a container class, this means it has a structural role
    % in the experiment builder platform. The class is used to store the
    % 'links' or 'connections' between the different elements that will be
    % executed in the experiment.
      
    properties (SetAccess = private)
        trials
        
        name
        
        parentCondition
        
        ID
    end
    
    methods
        function obj = Block(name)
            obj.name = name;
            obj.trials = Trial.empty(0,0);
              
            %set object unique ID
            obj.ID = java.rmi.server.UID();
            
        end
        
        function disp(obj)
            disp('---Trial List---');
            disp(obj.trials);
            disp('---------------');
        end
       
        function trialObj = getTrial(obj,name)
            for i=1:size(obj.trials,2)
                if(strcmp(obj.trials{i}.name,name))
                    trialObj = obj.trials{i};
                    break;
                end                
            end
        end
        
%         function trials = get.trials(obj)
%             disp('retrieving trials');
%             trials = obj.trials;
%         end
        
        function deleteTrial(obj,trialName)
            for i=1:size(obj.trials)
                if(strcmpi(obj.trials(i).trialName,trialName))
                    obj.trials(i) = [];
                    disp([trialName,' has been removed']);
                end
            end
        end
        
        function addTrial(obj,trial)
%             try
                disp(['trial ',trial.name,' added'])
                obj.trials{end+1} = trial;
                
%             catch
%                 disp('could not add trial, check for error');
%             end
        end
        
        function ttable = showTimetable(obj)
            %loops explanation:
            % every trial has a timetable, the timetable's size is -1 from
            % the amount of frames in the trial itself. the loops go
            % through each trial, and within it - extract the timing
            % between each 2 consecutive frames. when a negative value is
            % presented this means user input is expected.
            
            for i=1:size(obj.trials)
                for k=1:(size(obj.trials(i).trialFrames)-1)
                    ttable(i).timing(k) = obj.trials(i).timeTable(k);
                end % end of k trial timing loop
            end % end of i trials loop
        end
        
        %get object ID
        function ID = getID(obj)
            ID = obj.ID;    
        end
    end
    
    
end

