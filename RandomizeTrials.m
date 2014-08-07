classdef RandomizeTrials < handle
    
    properties
        trials
        
        symbolicDistribution
        
        ratios
        
        sizeVector
        
        conditions
        
        howLong = 20;
    end
    
    properties (SetAccess = private)
        restr = {} ;
        demands = {};
    end
    
    methods
        function obj = RandomizeTrials(trials,ratios,size)
            obj.sizeVector = size;
            obj.trials = trials;
            obj.ratios = ratios;
        end
        
        function createDistribution(obj)
            obj.symbolicDistribution = randp(obj.ratios,obj.sizeVector,1);
            
            %the results of the above command are symbolic and will be used
            %in analog to trials. each number (integer) generated will be
            %assigned to a corresponding trial.
        end
        
        function permutateAgain(obj)
            obj.symbolicDistribution = Shuffle(obj.symbolicDistribution);
        end
        
        function conditionSet(obj,condition)
            %structure of condition:
            %{1,[1,2,....n]} - a demand for consecutive order of the items (throughout the sequence)
            %{0,[1,2,...n]} - a restriction - do not let these values to be consecutive
            %a cell array of 1x2
            if(condition{1} == 1)
                obj.demands{end+1} = condition{2};
            else
                obj.restr{end+1} = condition{2};
                
            end
        end
        
        function checkDistribution(obj)
            finder = @findPattern2;
            
            %required pattern - requires more thought :)
            %             for requiredPatternIterator=1 : size(obj.demands,2)
            %                 found = finder(obj.symbolicDistribution,obj.demands{requiredPatternIterator});
            %
            %                 end
            %             end
            
            % search for the restrictions within the sequence !
            for requiredPatternIterator=1 : size(obj.restr,2)
                found{requiredPatternIterator} = finder(obj.symbolicDistribution,obj.restr{requiredPatternIterator});
            end
            
            if(sum(cellfun(@isempty,found)) ~= size(obj.restr,2))
                %BAD - we have crossed our rule !
                %right now - we permutate again, but we can have other
                %solutions...
                tic;
                obj.permutateAgain;
                %call itself again...
                %check if time elapsed isn't too long
                if(toc < obj.howLong)
                    obj.checkDistribution;
                else
                    disp('combination not found within given time frame... sorry - problem is too complex');
                end
            else
                disp('Good permu;'tation found!');
            end
        end
    end
end