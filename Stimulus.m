%  stimuli string, color of stimuli, position,
classdef Stimulus < handle
    %STIMULI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Hidden)
        image
        
        parentTrialFrame
    end
    
    % The following properties can be set only by class methods
    properties (SetAccess = private)
        rendered = 0;
    end
    
    methods
        function renderStimuli(src,evnt)
            obj.rendered = true;
            disp('you called me');
            
            %let's paint!
            w = src.screenPointer;
            
            
            %draw the stimulus contained in this stimulus object
%             Screen('Preference','DebugMakeTexture', 1);
            Screen('MakeTextutre', w,obj.image);
            
            %explanation:
            %the stimulus is drawn into the back buffer of the ptb window,
            %once the drawing is completed, the function ends as far as
            %this stimulus is concerned and rendering contiunes via the
            %trialframe class.
        end
        
        %CONSTRUCTOR function - set up the stimulus object - initialization
        function obj = Stimulus(imageMatrix,parentTrialFramePointer)
                obj.parentTrialFrame = parentTrialFramePointer;
                obj.image = imageMatrix;
  
                %listen for render commands
                renderListener = addlistener(obj.parentFrame,'renderStimuli',@Stimulus.renderStimuli);
        end
        
        function disp(obj)
           disp('Stimuli image name');
           disp(obj.image);
           disp('Parent Trial Frame');
           disp(obj.parentTrialFrame);
        end
            
        
        function set.parentTrialFrame(obj,parentFrame)
            %set by the trial frame that will be "the director"
            obj.parentTrialFrame = parentFrame;
        end
        
        function parent = get.parentTrialFrame(obj)
            parent = obj.parentTrialFrame;
        end
    end
    
end

