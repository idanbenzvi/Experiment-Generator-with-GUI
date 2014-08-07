%  stimuli string, color of stimuli, position,
classdef Stimulus < handle
    %STIMULI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Hidden)
        stringStim
        
        position
        
        size
        
        color
        
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
            Screen('DrawText', w, obj.stringStim, obj.position(1),obj.position(2), obj.color);
            
            %explanation:
            %the stimulus is drawn into the back buffer of the ptb window,
            %once the drawing is completed, the function ends as far as
            %this stimulus is concerned and rendering contiunes via the
            %trialframe class.
        end
        
        %CONSTRUCTOR function - set up the stimulus object - initialization
        function obj = Stimulus(stringStimulus,sizes,positions,colors,parentTrialFramePointer)
            if nargin > 4
                obj.stringStim = stringStimulus;
                obj.size = sizes;
                obj.position = positions;
                obj.color = colors;
                obj.parentTrialFrame = parentTrialFramePointer;
                
                renderListener = addlistener(obj.parentFrame,'renderStimuli',@Stimulus.renderStimuli);
            else
                obj.stringStim = stringStimulus;
                obj.size = sizes;
                obj.position = positions;
                obj.color = colors;
            end
        end
        
        function disp(obj)
            disp(['Position: ',obj.position]);
            disp(['Size: ',obj.size]);
            disp(['String: ',obj.stringStim]);
            disp(['Color Vector: ',obj.color]);
%             if(~isempty(obj.parentTrialFrame))
%                 disp('Parent Trial Frame: ');
%                 disp(obj.parentTrialFrame);
%             end
        end
        
        function a = get.color(obj)
            %open a new figure window
            if(~isempty(obj.color))
                %rectangle('FaceColor',[str2double( obj.color{1}),str2double( obj.color{2}),str2double( obj.color{3})]);
                a = obj.color;
            else
                a = [];
            end
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

