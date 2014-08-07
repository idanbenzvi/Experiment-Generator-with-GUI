classdef Condition < handle
    properties (SetAccess = private)
        blocks
        
        name
        
        objectTable
        
        parentExperiment
        
        ID
    end
    
    methods
        function obj = Condition(conditionName,varargin)
            %set object name
            obj.name = conditionName;
            
            %set object unique ID
            obj.ID = java.rmi.server.UID();
            
            %set object tree (for blocks)
            obj.objectTable = Tree2Object();
            
            %add blocks to strucure if they are given in constructor,
            %otherwise create an empty array of blocks
            if(nargin ==2)
                obj.blocks = varargin{1};
            else
                obj.blocks = Block.empty(0,0);
            end
        end
        
        function disp(obj)
            disp('---Condition Name---');
            disp(obj.name);
            disp('------------------------');
        end
        
        function setParent(obj,expObject)
            obj.parentExperiment = expObject;
        end
        
        function addBlock(obj,block)
            disp(['added the block ',block.name',' to condition ',obj.name]);
            obj.blocks(end+1) = block;
            
            %add to objectTree (children)
            obj.objectTable.addObj(block.getID,'block');
        end
        
        function ID = getID(obj)
            ID = obj.ID;    
        end
        
        %retrieve a handle to the Block with the specified name
        function blockObj = getBlock(obj,name)
            %TBD - change this - get handle from treeobject
            for i=1:size(obj.blocks,2)
                if(strcmp(obj.blocks(i).name,name))
                    blockObj = obj.blocks(i);
                    break;
                end                
            end
        end
        %
        %         function trials = get.trials(obj)
        %             disp('retrieving condition trials');
        %             trials = obj.trials;
        %         end
        %
        %         function deleteTrial(obj,trialName)
        %             for i=1:size(obj.trials)
        %                 if(strcmpi(obj.trials(i).trialName,trialName))
        %                     obj.trials(i) = [];
        %                     disp([trialName,' has been removed']);
        %                 end
        %             end
        %         end
        %
        %         function addTrial(obj,trial)
        %             try
        %                 obj.trials(end+1) = trial;
        %                 disp(['trial ',trial.trialName,' added']);
        %             catch
        %                 disp('could not add trial, check for error');
        %             end
        %         end
        %
        % %         function ttable = showTimetable(obj)
        % %             %loops explanation:
        % %             % every trial has a timetable, the timetable's size is -1 from
        % %             % the amount of frames in the trial itself. the loops go
        %             % through each trial, and within it - extract the timing
        %             % between each 2 consecutive frames. when a negative value is
        %             % presented this means user input is expected.
        %
        %             for i=1:size(obj.trials)
        %                 for k=1:(size(obj.trials(i).trialFrames)-1)
        %                     ttable(i).timing(k) = obj.trials(i).timeTable(k);
        %                 end % end of k trial timing loop
        %             end % end of i trials loop
        %         end
        %
        %         function childList = getChildren(obj)
        %             for(i=1:size(trials,2))
        %                 childList(i) = obj.trials(i).name;
        %             end
        %         end
        %
        %     end
        
        
    end
end

