function [ cordxy ] = nor2cart( cordNor )
%NOR2CART Summary of this function goes here
%   Detailed explanation goes here


screens=Screen('Screens');
screenNumber=max(screens);

Resolution=Screen('Resolution', screenNumber);

%convert
cordxy = [Resolution.width*cordNor(1),Resolution.height*cordNor(2)];

end

