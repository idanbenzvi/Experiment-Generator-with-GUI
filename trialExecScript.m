%create trial
%create trialframe
a(1) = TrialFrame('one',imread('bg.jpg'));
a(2) = TrialFrame('two',imread('pic.jpg'));
%create time table
timer = TimeTable({500,250});
%create Trial
newTrial = Trial('amazing',a,timer);

%create a screen
w = Screen('OpenWindow',0);
%pass the screen pointer to the trial
% -> raster textures
newTrial.setScreenPointer(w);
disp('reached HERE ! ');
% sca
KbQueueCreate;
KbQueueStart;
executor = TrialExecute(newTrial,w);

disp('wow');
% yay = Screen('maketexture',w,imread('pic.jpg'));
% Screen('drawTexture',w,yay);
% Screen('flip',w);
% WaitSecs(2);
sca
%use the trailexector

