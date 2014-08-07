classdef Experiment < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        name
        
        conditions
        
        parameters
        
        dataOutputFile
        
        objectTree
        
        objectTable
        
        ID
    end
    
    methods
        function obj = Experiment(name)
            %experiment name
            obj.name = name{1};
            
            %uniqe ID
            obj.ID = java.rmi.server.UID;
            
            disp('new Experiment created...');
            
            %create object reference (handles) table - required for
            %modification of objects later on (a link between objects and
            %their ID within the tree)
            obj.objectTable = Tree2Object();
            obj.objectTable.addObj(obj.ID,'experiment');
            %initialize a structure for conditions
            obj.conditions = Condition.empty(0,0);
            
        end
        
        function result = addCondition(obj,condition)
            %initialize variable donotadd
            donotadd = false;
            
            %check if condition doesn't already exist
            if(size(obj.conditions) == 0)
                obj.conditions(end+1) = condition;
                disp(['added condition ',condition.name,' to experiment']);
                obj.objectTable.addObj(condition.getID,'condition');
                result = true;
            else
                for i=1 : numel(obj.conditions)
                    if(strcmp(obj.conditions(i).name,condition.name))
                        disp('name already found in experiment, aborting addition of condition');
                        donotadd = true;
                        result = false;
                        break;
                    end
                end
                
                if ~donotadd
                    %return true, the addition will be made
                    result = true;
                    %add new object to the object table
                    obj.objectTable.addObj(condition.getID,'condition');
                    %add the condition object handle to conditions in
                    %object
                    obj.conditions(end+1) = condition;
                    disp(['added condition ',condition.name,' to experiment']);
                end % end of if
            end
        end % end of function
        
        function removeCondition(obj,condition)
            %seek condition by name and remove it
            for i=1 : numel(obj.conditions)
                if(strcmp(obj.conditions(i).name,condition))
                    disp('removing condition ');
                    obj.conditions(i) = [];
                    obj.objectTable.removeObj(condition(i).getID);
                    break;
                end
            end
        end
        
        function set.objectTree(obj,treeH)
            obj.objectTree = treeH;
            disp('added the object Tree to the experiment');
            %maybe i will need to add some code to the setting of the tree
        end
        
        %retrieve a handle to the condition with the specified name
        function conditionObj = getCondition(obj,ID)
            for i=1:size(obj.conditions,2)
                if(strcmp(obj.conditions(i).getID.toString,ID.toString))
                    conditionObj = obj.conditions(i);
                    break;
                end
            end
        end
        
        function type = findObjType(obj,ID)
            type = obj.objectTable.getType(ID);
        end
        
        function result = getID(obj)
           result = obj.ID ;
        end
    end % end of methods
    
    
end



