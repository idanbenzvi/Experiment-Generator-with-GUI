function trial  = wholeTrialBot(figureFileArray,timeTable)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %for debugging purposes only
    figureFileArray.file(1) = {'test_export'};
    figureFileArray.file(2) = {'test_export2'};
    
% as simple as this :) - simply read the figures and create trial frames    
for i=1:size(figureFileArray.file,2)
    %note 0 - a sign for no screen pointer for now
    trialFrames(i) = TrialFrame(readerBot(char(figureFileArray.file(i))),0);
end

%Create the trial itself via the Trial Class
trial = Trial(trialFrames,timeTable,0);

% the created trialFrames array will now be used to create the whole frame
% using the trial class
% using the trial class: 
% 1. the figures are already selected and await render commands
% 2. tbd - create the time table for the different frames - for each frame
% - give a length to display \ wait a specific keypress is made
% 3. (optional) add masker pre-made frames
% e.g.: Trial(trialFrameArray,timeTable,screenPointer)
end

