classdef Tree2Object < handle
    % this class serves as a linker between the obejcts and tree representing
    % the experiment hierarchy. It enables the reference to specifc objects
    % with ease and is required in order to maintain the uniqueness of objects
    % which cannot be retained by using simple naming (since a name might
    % repeat itself. for example, a trial that occurs more than once between
    % conditions).
    properties (SetAccess = private)
        treeObjectTable
    end
    
    %create an empty tree2object table
    methods
        function obj = Tree2Object()
            obj.treeObjectTable = {'',''};
            disp('object tree (tree2object class) created...');
        end
       
        function addObj(obj,ID,objType)
           %convert from cell string array to string
           if(iscell(ID)) 
              ID = ID{1}; 
           end
               
           obj.treeObjectTable{end+1,1} = ID;
           obj.treeObjectTable{end,2} = objType;
        end
        
        function removeObj(obj,ID)
            index = find(strcmp(obj.treeObjectTable, ID));
            obj.treeObjectTable{index} = [];
            obj.treeObjectTable{index} = [];
        end
        
        function type = getType(obj,ID)
            transposedTable = obj.treeObjectTable';
            transposedTable = cellfun(@(x) char(x),transposedTable,'UniformOutput',0);

            index = find(strcmp(transposedTable,char(ID)));
            type = transposedTable(index+1);
        end
    end
end

    