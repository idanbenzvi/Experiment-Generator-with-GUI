classdef TrialFrame < handle
    %TrialFrame - a single frame in the trial - waiting to be rendered
    %   the trialframe includes stimuli objects and once given the command,
    %   renders the stimuli into a texture.
    
    %%
    properties
        texture
    end
    
    % The following properties can be set only by class methods
    properties (SetAccess = private)
        rendered = 0
        screenPointer
        name = 'empty Trial'
        image = [];
        parentTrial % object heirarchy
        renderListener
        ID
    end
    
    %% Define an event - not yet used!
    events
        %render and return made texture drawn
        renderStimuli
    end
    
    %%
    methods
        %CONSTRUCTOR function - set up the stimulus object - initialization
        function obj = TrialFrame(name,image,trialScreenPointer)
            %set object unique ID
            obj.ID = java.rmi.server.UID();
            
            %build object according to arguments
            switch nargin
                case 0
                    disp('creating empty trial frame');
                    return
                    
                case 1
                    obj.name = name;
                    
                case 2
                    obj.name = name;
                    obj.image = image;
                    
                case 3
                    obj.name = name;
                    obj.screenPointer = trialScreenPointer;
                    obj.image = image;
                    
                    %in case the trial screen handle is given - raster the
                    %image immediately
                    rasterImage;
            end
            
        end
        
        function rasterImage(obj)
            %create a texture from the image VIA the screen handle
            if (~obj.rendered)
                obj.texture = Screen('MakeTexture', obj.screenPointer, obj.image);
                obj.rendered = 1;
            end
        end
        
        function assignScreenPtr(obj,ptr)
            obj.screenPointer =  ptr;
            obj.rasterImage;
            %            tex = obj.texture;
        end
        
        function childList = getChildren(obj)
            for(i=1:size(obj.stimuli,2))
                childList(i) = obj.stimuli(i).stringStim;
            end
        end
        
        function setParent(obj,parentTrial)
            obj.parentTrial = parentTrial;
            obj.renderListener = addlistener(obj.parentTrial,'renderTrialFrames',@(src,evnt)render(obj,src,evnt));
            
        end
        
        function ID = getID(obj)
            ID = obj.ID;    
        end
        
        
    end
end