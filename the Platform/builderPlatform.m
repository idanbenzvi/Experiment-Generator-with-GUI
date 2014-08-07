function [ output_args ] = builderPlatfrorm(loadOrCreate)
%BUILDERGUI Summary of this function goes here
%   Detailed explanation goes here


%main figure - draw interface
mainfigure.interfacewindow = figure('Visible','off',...
    'Units','normalized',...
    'Tag', 'main_figure',...
    'color','black',...
    'Position',[0.02, 0.1, 0.45, 0.59],...
    'MenuBar','none',...
    'Name','Snapshot archive tool',...
    'Resize','off',...
    'Toolbar','none',...
    'NumberTitle','off',...
    'DockControls','off',...
    'Color','black',...
    'CloseRequestFcn',@close_main_interface);


% exit

% conditions table

% trial table

% trial frame and order (some might share the same placement and therefore
% wlil be randomized) 
% e.g.:
% 1. fig1
% 2. fixation
% 3. tf1variation1
% 3. tf1variation2
% 3. tf1variation3
% 4. masker
% 5. tf2
% all trials numbered 3 will be randomized with each other each time the
% trial runs


%% internal functions
function close_main_interface(~,~)
    delete(mainfigure.interfacewindow);
end

% open file dialog
    function  load()
        
    end
% 



end

