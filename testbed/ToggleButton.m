classdef ToggleButton < handle
    properties
        State = false
    end
    events
        ToggledState
    end
    methods
        ...
            function OnStateChange(obj,newState)
            % Call this method to check for state change
            if newState ~= obj.State
                notify(obj,'ToggledState'); % Broadcast notice of event
                obj.State = newState;
            end
            end
    end
end