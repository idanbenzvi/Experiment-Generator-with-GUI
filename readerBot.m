function [ trialFrameStimuli ] = readerBot( figureName )
%readerBot reads through a GUIde generated figure window and creates a
%stimuli frame object
%   The readerBot is part of the generatorGUI package. this script reads
%   through the figure file and creates stimuli via the dismantling of
%   uicontrols into PTB drawn objects. The properties that define the
%   uicontrols are transformed into PTB properties and a corresponding PTB
%   screen frame that can be pre-rendered as part of a trial.
%   The readerBot, in summary, creates 1 frame of stimuli (of n frames that
%   compose the trail)
%
%   Author: Idan Ben-Zvi
%   Date: 17/12/2013
%
%   Status: proof of concept
%   Version: 0

% read the figure file and look for UIcontrols
fid = fopen([figureName,'.m']);
tline = fgets(fid);
linenum= 1;
i = 1;
clc;

%like a mole digging a hole... one line at a time
while ischar(tline)
    
    %look for stimuli
    if(strfind(tline,'uicontrol('))
        disp(['found stimuli at line: ',num2str(linenum)]);
        
        %create new stimuli object
        %!!!!! NOT DONE !!!! - initialization of the stimuli object has
        %to be done once all stimulus is collected
        
        
        %inner loop - property setting loop
        %this loop reads through the uicontrol properties and collects them
        %in order to convert them later onto PTB compatible info.
        while(isempty(strfind(tline,';'))) 
            %set position
            if(size(strfind(tline,'Position'))>0)
                disp('setting normalized position');
                tline = strrep(tline,'Position','');
                expression ='\s?\d+\.+\d*+\s?';
                coordinates = regexp(tline,expression,'match')
            end
            %set text size
                if(size(strfind(tline,'FontSize'))>0)
                disp('setting string size');

                %do not modify - higly volatile expression
                expression ='\d+';
                stringStimSize = regexp(tline,expression,'match')
            end
            
            
            %set text
            if(size(strfind(tline,'String'))>0)
                disp('setting string');

                %do not modify - higly volatile expression
                expression =sprintf('(?<='',).*(?='')');
                stringStim = regexp(tline,expression,'match')
            end
            
            
            %set text color
            if(size(strfind(tline,'ForegroundColor'))>0)
                disp('setting string color');
                
                %do not modify - higly volatile expression
                expression ='\d+';
                stringStimColor = regexp(tline,expression,'match')
            end
            
            %move on to the next line in the figure code
            linenum = linenum +1;
            tline = fgets(fid);
        end;
        
       
        %% initialize the stimulus object using the constructor
        trialFrameStimuli.stimuli(i) = Stimulus(stringStim,stringStimSize,coordinates,stringStimColor);
        % stimuli counter - for the stimuli struct
        i = i+1;
        
    end;
    
    %move onto the next line of the GUI code
    linenum = linenum +1;
    tline= fgets(fid);
end
fclose(fid);


% extract the text if there is any - or if the word image is used -
% create a placedholder for the image.
end

