classdef RespondToToggle < handle
    methods
        function obj = RespondToToggle(toggle_button_obj)
            addlistener(toggle_button_obj,'ToggledState',@RespondToToggle.handleEvnt);
        end
    end
    methods (Static)
        function handleEvnt(src,evtdata)
            if src.State
                disp(' called and said that ToggledState is true') % Respond to true ToggleState here
            else
                disp(' called and said that ToggledState is false') % Respond to false ToggleState here
            end
        end
    end
end