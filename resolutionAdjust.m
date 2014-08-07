function resolutionAdjust(width,height,Hz)
%ResolutionAdjust allows for pre-experiment setup of the screen resolution
%and ensure its refresh rate.
%Arguementss:
% width - screen res. width
% height - screen res. height
% Hz - refresh rate
%
%Returned variable :
%none - just resolution change.
%
%Attention:
%please note - this function must be run BEFORE the experiment starts since
%PTB requires you close all open windows before changing resolution.
%Therefore, all existing texture data etc, will be deleted after calling
%this function.

if(nargin < 3)
    disp('please insert width, height, refresh rate.');
else
    
    sca % close all open PTB windows
    
    %change screen resolution according to arguement values
    Screen('Resolution',0,width,height,Hz);
    
%     %open new PTB window and return handle to callier
%     %in case a bg color is required before hand - a 4th argument in the
%     %form of a 3x1 array : i.e. [r g b] can be supplied:
%     if(nargin > 3)
%         scrnPtr = Screen('openWindow',0,varargin{1});
%     else
%         scrnPtr = Screen('openWindow',0);
%     end
end
end

