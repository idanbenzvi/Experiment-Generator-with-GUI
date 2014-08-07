%resizer example
%script to see if the trial executor system works

%create a timetable
% rotating hemifield flickering checkerboard 
rcycles = 12; % number of white/black circle pairs 
tcycles = 5; % number of white/black angular segment pairs (integer) 
flicker_freq =  8; % full cycle flicker frequency (Hz) 
flick_dur = 1/flicker_freq/2; 
period = 30; % rotation period (sec) 
 
[w, rect] = Screen('OpenWindow', 0, 128); 
img=imread('bg.jpg'); 
[yimg,ximg,z]=size(img); 
rot_spd = 10; % rotation speed (degrees per frame) 
larrow = KbName('left'); % modify this for Windows? 
rarrow = KbName('right'); 

sx = 400; % desired x-size of image (pixels) 
sy = yimg*sx/ximg; % desired y-size--keep proportional 
t = Screen('MakeTexture',w,img); 
bdown=0; 
th = 0; % initial rotation angle (degrees) 
HideCursor 
while(~any(bdown)) % exit loop if mouse button is pressed 
 [x,y,bdown]=GetMouse; 
 
 [keyisdown,secs,keycode] = KbCheck; 
 if(keycode(larrow)) 
 th = th - rot_spd; % rotate counterclockwise 
 end 
 if(keycode(rarrow)) 
 th = th + rot_spd; % rotate clockwise 
 end 
 
 destrect=[x-sx/2,y-sy/2,x+sx/2,y+sy/2]; 
 Screen('DrawTexture',w,t,[],destrect,th); 
 Screen('Flip',w); 
end 
Screen('Close',w) 
ShowCursor 

%create 

%