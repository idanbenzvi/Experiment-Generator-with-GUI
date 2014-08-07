classdef TrialExecute < handle
    
    % right now !
    % KbQueueCreate
    % KbQueueStart
    % should be called outside of the trialexecute function in order
    % to use the KbQueue properly
    
    properties
        screenHandle
        
        trial
    end
    
    properties (SetAccess = private)
        timings ;
        textureArray;
        userInput;
    end
    
    methods
        function obj = TrialExecute(trial,screenHandle)
            obj.trial = trial;
            obj.screenHandle = screenHandle;
            %             obj.keyboardQueueHandle = keyboardQueueHandle;
            
            %get timetable from the trial timeTable object
            obj.timings = obj.trial.getTimeTable;
            %get all the textures ready !
            obj.textureArray = obj.trial.getTextures;
            %raster the trial textures if not already done (1st run of
            %trial requires rastering)
            % after the rastering - execute the trial
            obj.executeTrial;
            
        end
        
        %render the trial textures if not already done (can be checked
        %with a built in method or simply create the code in such a way a
        %trial will always be rastered before its execution making this
        %redundant
        
        function executeTrial(obj)
            %           disp('drawing textures to screen');
            %Display a frame
            
            %does this frame require user input ?
            
            %if not specified between the frames - user input will be
            %collected in the end
            if(obj.timings{end} < 0)
                endCollect = false;
            else
                endCollect = true;
            end
            
            for i=1 : numel(obj.textureArray)
                %display each texture for the specified amount of time
                Screen('DrawTexture',obj.screenHandle,obj.textureArray(i));                
                Screen('flip',obj.screenHandle);
                
                if(i < (numel(obj.textureArray)))
                    %if we are dealing with an array
                    if(size(obj.timings{i},1) > 1)
                        %uniform random to select the timing
                        
                        %select randomly one out of the options...
                        idx=randi(numel(obj.timings{i}));
                        %wait for the randomized amount of time
                        WaitSecs(obj.timings{i}(idx)/1000);
                        disp('random wait');
                    else
                        %wait a specified period (Ms)
                        if(obj.timings{i} >= 0)
                            WaitSecs(obj.timings{i}/1000);
                            disp('waited for you');
                            disp(obj.timings{i}/1000);
                        else
                            %await user input
                            obj.collectInput(obj)
                        end
                    end
                else %check if this trial requires data collection only at the end
                    if(endCollect)
                        obj.collectInput;
                    end
                end
            end
            
        end
        
        %input gathered consists of a single character and single RT
        %of course this can be altered in future versions
        function collectInput(obj)
            %await user input
            [~,timing] = KbQueueCheck();
            
            %log user RT and key prsesed
            obj.userInput.key = KbName(timing);
            obj.userInput.RT = timing;
        end
    end
end
