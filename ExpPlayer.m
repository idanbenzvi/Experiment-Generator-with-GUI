classdef ExpPlayer < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        experimenterName
        
        currentSubjectID
        
        currentSubjectName
        
        playCount 
        
        testRun
        
        Conditions
        
        specialKeyTable
        
        screenSelector
        
        showControlInterface
        
        positionWithinExperiment % in percent
        
        trials
        
        dataFile
        
        %userKeyPresses
        %userRT
        %trialTotalTime
        %all in the dataset - BlockResults
    end
    
    methods
        function obj = ExpPlayer(trials)
         obj.trials = trials
        end
        
        function disp(obj)
            
        end
        % TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD
        % calling the play command executes the trial. the frames are
        % displayed on screen and behavior is dictated by the time table
        % contained within the trial.
%         the result of the keypresses will be logged, not yet sure where
%         to...
        

        function results = play(obj)
           %display trial with frames
           
           %get the user's answer and save RT along with trial total time
           %and correct / wrong into a structure
           
           %once running is complete - return the results struct
           results = 1;
        end
      
        function createAnimation(obj)
            
        end
        
        function results = get.played(obj)
            
        end
        
        function results = get.results(obj)
            results = obj.blockResults;
        end
        
        %WTF?! make sure we don't let the user learn patterns of correct
        %answers because we put specified trials "together"
        function intelliBlender(obj,trial2x)
            
        end
        
        function displayRunningOrder
            
        end
       
    end
    
    methods (Acesss = Private)
        function randomizeTrials()
            
        end
        
        function randomizeConditions()
            
        end
        
        function randomizeBlocks()
            
        end
    
    end
end

