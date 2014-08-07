function [ output_args ] = builderGUI( varargin )
%BUILDERGUI Summary of this function goes here
%   Detailed explanation goes here

%add to path - mini function
addpath(genpath(pwd));

%display splash screen while "drawing" the interface"
%dos('mpc-hc.exe "intro animation_v002_4.mp4" /fullscreen /close');
%initBuilder;

%% main figure - draw interface
mainfigure.interfacewindow = figure('Visible','on',...
    'Units','normalized',...
    'Tag', 'main_figure',...
    'Position',[0.1, 0.2, 0.75, 0.6],...
    'MenuBar','none',...
    'Name','Experiment Builder',...
    'Resize','off',...
    'Toolbar','none',...
    'NumberTitle','off',...
    'DockControls','off',...
    'Color','white',...
    'CloseRequestFcn',@close_main_interface);

    setappdata(mainfigure.interfacewindow','tabledata',[]);

%% create panel as placeholder for image (drawn in axis within the panel)
% this is for the logo image which will also serve as an About button
mainfigure.logoPanel = uipanel('FontSize',10,...
    'BorderType','none',...
    'BackgroundColor','white',...
    'Position',[.001 .875 .15 .13],...
    'handlevisibility','on',...
    'parent',mainfigure.interfacewindow,...
    'visible','on');

mainfigure.logoGraphAxes = axes('box','off','parent',mainfigure.logoPanel);

 logoDispImage = imread('.\images\logo.jpg');
 imshow(logoDispImage,'border','tight','initialmagnification','fit','parent',mainfigure.logoGraphAxes);
    
%% input arguements - if an exp file is selected
if(size(varargin) < 0)
    if(exist(varargin{1} ,'file'))
        disp(['opening ',varargin{1},' and loading its assets']);
        openExperiment(varargin{1});
    end
end

%% Tree Initialization

TreePosition = [5 5 200 625];
%     TreeH = javacomponent(M_treeH, TreePosition, mainfigure.interfacewindow);
[TreeH, mainfigure.interfacewindowtree] = uitree('v0', 'Root','C:\', 'Parent',mainfigure.interfacewindow); % Parent is ignored
myRoot = uitreenode('v0','','Start a new experiment!', '.\icons\exp.png',true);
TreeH.setRoot(myRoot);
set(mainfigure.interfacewindowtree, 'Parent', mainfigure.interfacewindow);  % fix the uitree Parent
set(mainfigure.interfacewindowtree,'Position',[5 5 200 625]);

set(TreeH, ...
    'Visible',                  1, ...  %[JS] 0 or 1
    'MultipleSelectionEnabled', 0, ...
    'NodeWillExpandCallback',   {@nodeSelectedFcn, mainfigure.interfacewindow}, ...
    'NodeExpandedCallback',     {@nodeSelectedFcn,   mainfigure.interfacewindow}, ...
    'NodeSelectedCallback',     {@nodeSelectedFcn,   mainfigure.interfacewindow});

%%image display - next phase
%create invisible axis in which images will be displayed. the imgca command
%is useful as well as imshow / imread  etc.
% set axis visible only after stimulus is selected  and off once it is not.


%% listbox tree controls
mainfigure.treeControlPanel = uipanel('Title','Available Actions','FontSize',10,...
    'BorderType','etchedin',...
    'BackgroundColor','white',...
    'Position',[.15 .683 .15 .3],...
    'handlevisibility','on',...
    'parent',mainfigure.interfacewindow,...
    'visible','on');

mainfigure.listBox = uicontrol('style','listbox','units','normalized',...
    'parent',mainfigure.treeControlPanel,...
    'position',[0.01 0.01 0.95 0.95],...
    'string',['select node'],...
    'enable','off',...
    'HandleVisibility','on',...
    'tag','listbox',...
    'callback',@listSelection);

%% user ui menu
interfacewindow.menu = uimenu('Label','File');
uimenu(interfacewindow.menu,'Label','New Experiment','Callback',{@startNew,mainfigure,TreeH},'Accelerator','N');
uimenu(interfacewindow.menu,'Label','Open Experiment','Callback',@openExperiment,'Accelerator','O');
uimenu(interfacewindow.menu,'Label','Save','Callback',{@saveExperiment,mainfigure,TreeH},'Accelerator','S');
uimenu(interfacewindow.menu,'Label','Quit','Callback',@close_main_interface,...
    'Separator','on','Accelerator','Q');
interfacewindow.menu = uimenu('Label','About');
uimenu(interfacewindow.menu,'Label','About Us...','Callback',@aboutUs,'Accelerator','H');

%  Downards spiral of heirarchy
% view experiment currently open
% mainfigure.experiment

% view condition list by name
% mainfigure.condition

%view trial list by name
% mainfigure.trial

%experiment management - 'player' properties
mainfigure.controlPanel = uipanel('Title','Controls','FontSize',10,...
    'BorderType','etchedin',...
    'BackgroundColor','white',...
    'Position',[.15 .01 .3 .3],...
    'parent',mainfigure.interfacewindow,...
    'visible','on');

mainfigure.allFields = uicontrol('Style','pushbutton',...
    'units','normalized',...
    'Position',[.01 .01 .3 .15],...
    'String','Field Editor',...
    'Parent',mainfigure.controlPanel,...
    'callback','cla'); % dont forget to add callback function

mainfigure.trialstimuliPanel = uipanel('Title','Trial Properties','FontSize',10,...
    'BorderType','etchedin',...
    'BackgroundColor','white',...
    'Position',[.69 .31 .15 .68],...
    'parent',mainfigure.interfacewindow,...
    'visible','on');

%trial properties table

% mainfigure.trialStimuliTable = uitable('parent', mainfigure.trialstimuliPanel,...
%     'Units','normalized',...
%     'position', [0.01 0.05 0.97 0.92] ,...
%     'data', getappdata(mainfigure.interfacewindow,'tabledata'),...
%     'columnName',{'Property','Value'},...
%     'rowName',[]);

% view list of stimuli with properties
mainfigure.imageListBox = uicontrol('style','listbox','units','normalized',...
    'parent',mainfigure.interfacewindow,...
    'position',[0.15 0.31 0.15 0.37],...
    'string','',...
    'enable','on',...
    'HandleVisibility','on',...
    'tag','imagelistbox',...
    'visible','on',...
    'max',5,...
    'min',1,...
    'enable','off',...
    'callback',@imageListSelection);

%% set initial directory listing using pwd
load_listbox(pwd)
handles.listbox = 'imageselection';

%% Time Tables for trials within this block
mainfigure.timetable = uipanel('Title','TimeLine','FontSize',10,...
    'BorderType','etchedin',...
    'BackgroundColor','white',...
    'Position',[.845 .31 .15 .68],...
    'parent',mainfigure.interfacewindow,...
    'visible','on');

% Define parameters for a uitable (col headers are fictional)
colnames = {'trialname1', 'trialname2', 'trialname3'};
% All column contain numeric data (integers, actually)
colfmt = {'char', 'char', 'char'};
% Disallow editing values (but this can be changed)
coledit = [true true true];
% Set columns all the same width (must be in pixels)
colwdt = {60 60 60};
% Create a uitable on the left side of the figure

uh = uicontextmenu;
uimenu(uh,'label','Add a new row','callback',@addNewRow)
uimenu(uh,'label','remove last row','callback',@removeLastRow)

mainfigure.htable = uitable('Units', 'normalized',...
                 'parent',mainfigure.timetable,...
                 'Position', [0.001 0.001 0.99 0.99],...
                 'Data',  {'1','2','3'},... 
                 'ColumnName', colnames,...
                 'ColumnFormat', colfmt,...
                 'ColumnWidth', colwdt,...
                 'ColumnEditable', coledit,...
                 'ToolTipString',...
                 'Select cells to highlight them / right click to add new rows',...
                 'CellSelectionCallback', {@select_callback},...
                 'uicontextmenu',uh);

             
% add a new row to timing data
    function addNewRow(src,eventData)
%hTable: handle to the table
%newRow : the row of data you want to add to the table.
disp('adding new row...');
oldData = get(mainfigure.htable,'Data');
oldData{end+1,end} = [];
newData= oldData;
set(mainfigure.htable,'Data',newData)
    end

% add a new row to timing data
    function removeLastRow(src,eventData)
%hTable: handle to the table
%newRow : the row of data you want to add to the table.
disp('adding new row...');
oldData = get(mainfigure.htable,'Data');
oldData(end,:) = [];
newData= oldData;
set(mainfigure.htable,'Data',newData)
    end


%% preview pane
mainfigure.previewPane  = uipanel('Title','Preview Pane','FontSize',10,...
    'BorderType','etchedin',...
    'BackgroundColor','white',...
    'Position',[.31 .31 .37 .673],...
    'parent',mainfigure.interfacewindow,...
    'visible','on');

%axis are required in order to contain the image previews
paneGraphAxes = axes('parent',mainfigure.previewPane);

%enalbe the option to view the image in a full image viewer style
mainfigure.fullImageDisplay = uicontrol('Style','pushbutton',...
    'units','normalized',...
    'Position',[.35 .01 .3 .1],...
    'String','Full Size View',...
    'Parent',mainfigure.previewPane,...
    'callback',@imageShower); % dont forget to add callback function

% TBD: if a trial is selected and not a trial frame - replace the preview
% pane image preview with a slider and an image preivew of each trial frame
% according to the timeline. this means adding a slider in the bottom,
% configure its values (range) according to the timetable and chaning the
% image displayed according to the position

%% a graph
% mainfigure.timetableGraph  = uipanel('Title','Timeline Graph','FontSize',10,...
%     'BorderType','etchedin',...
%     'BackgroundColor','white',...
%     'Position',[.595 .01 .4 .3],...
%     'parent',mainfigure.interfacewindow,...
%     'visible','on');
% 
% %TBD TBD TBD
% mainfigure.haxes = axes('Units', 'normalized',...
%              'Position', [.465 .065 .50 .85],...
%              'XLim', [0 1],...
%              'YLim', [0 2],...
%              'XLimMode', 'manual',...
%              'YLimMode', 'manual',...
%              'XTickLabel',...
%              {'12 AM','5 AM','10 AM','3 PM','8 PM'});
% title(mainfigure.haxes, 'Trial TimeTables')   % Describe data set
% % Prevent axes from clearing when new lines or markers are plotted
% hold(haxes, 'all')
% 
% % Create an invisible marker plot of the data and save handles
% % to the lineseries objects; use this to simulate data brushing.
% hmkrs = plot([1,2,3], 'LineStyle', 'none',...
%                     'Marker', 'o',...
%                     'MarkerFaceColor', 'y',...
%                     'HandleVisibility', 'off',...
%                     'Visible', 'off');
% % Create an advisory message (prompt) in the plot area;
% % it will vanish once anything is plotted in the axes.
% axpos = get(haxes, 'Position');
% ptpos = axpos(1) + .1*axpos(3);
% ptpos(2) = axpos(2) + axpos(4)/2;
% ptpos(3) = .4; ptpos(4) = .035;
% hprompt = uicontrol('Style', 'text',...
%                     'Units', 'normalized',...
%                     'Position', ptpos,... % [.45 .95 .3 .035],...
%                     'String',...
%                       'Use Plot check boxes to graph columns',...
%                     'FontWeight', 'bold',...
%                     'ForegroundColor', [1 .8 .8],...
%                     'BackgroundColor', 'w');
                
                axis auto
axis on
%% internal functions

%display the image and update the display once  a new one is selected from
%the listbox
    function updateImage(filename)
        dispImage = imread(filename);
        imshow(filename,'border','tight','parent',paneGraphAxes);
        setappdata(mainfigure.previewPane,'displayImage',dispImage);
    end


    function  startNew(event,src,mainfigure,TreeH)
        %get exp name
        nameExp = inputdlg('Experiment Name','Name New Experiment',1);
        newExperiment = Experiment(nameExp);
        setappdata(mainfigure.interfacewindow,'currentExperiment',newExperiment);
        %clear the current tree from the workspace and also from the logical
        %stnadpoint
        TreeH.setRoot([]);
        
        %addition of epxerimental units will be put into the new experiment
        %object and its tree will be generated accordingly.
        %set the root node name
        myRoot = uitreenode('v0',newExperiment.getID, nameExp , '.\icons\experiment.png', false);
        TreeH.setRoot(myRoot);
    end

    function imageShower(src,eventData)
        imagetoShow = getappdata(mainfigure.previewPane,'displayImage');
        imtool(imagetoShow);
    end

    function initBuilder(~,~)
        s = SplashScreen('Experiment Builder','.\images\loading.gif');
        s.addText( 30, 50, 'Visual Attention Lab', 'FontSize', 30, 'Color', 'red' );
        s.addText( 30, 80, 'Experiment Creation Platform', 'FontSize', 20, 'Color', 'red' );
        s.addText( 30, 200, 'Loading GUI...', 'FontSize', 20, 'Color', 'white' );
        s.addText( 30, 630, '--- beta build --- Please report any errors to visualattentionlab@yahoo.com', 'FontSize', 10, 'Color', 'white' );
        s.ProgressBar = 'on';
        s.ProgressPosition = 10;
        %arbitrary wait time required to initialize the GUI nicely...
        i = 0;
        while(i < 10)
            s.ProgressRatio = (0.1)*i;
            i = i + 0.25;
            pause(0.002);
        end
        KbWait();
        delete(s);
    end

    function close_main_interface(~,~)
        delete(mainfigure.interfacewindow);
    end

    function drawTimetable(objectHandle,data)
        drawTimeLine(objectHandle,data);
    end

    function nodeSelectedFcn(src,eventData,varargin)
        %populate the listbox with the options available for this kind of
        %object
        
        %make the selected node available for other functions
        setappdata(mainfigure.interfacewindow,'selectedNode',eventData.getCurrentNode);
        %         eventData.getCurrentNode
        
        %the type of node is recognizable VIA its value
        if(~(eventData.getCurrentNode.getValue == 0))
       
            experimentHandle = getappdata(mainfigure.interfacewindow,'currentExperiment');
            
            %identify the object ID by the node value
            objectID = eventData.getCurrentNode.getValue;
            %if an encoded UID, convert to string
            if(isa(objectID,'java.rmi.server.UID'))
                
%             %identify the object type
%             objectType = experimentHandle.findObjType(objectID);
%             else
                objectType = experimentHandle.findObjType(objectID);
            end
            
            
            %convert the cell to string
            if(iscell(objectType))
                objectType = objectType{1};
            end
        
        switch objectType
            %experiment node
            case 'experiment'
                list = {'create new condition', 'save experiment'};
                set(mainfigure.listBox,'Enable','on');
                set(mainfigure.listBox,'String',list);
                %condition node
            case 'condition'
                list = {'create new block' 'delete current condition' 'duplicate current condition'};
                set(mainfigure.listBox,'String',list);
                
                %block node
            case 'block'
                list = {'create new trial (Manual)' 'Create trials Wizard' 'delete current block' 'duplicate current block'};
                set(mainfigure.listBox,'String',list);
                
                %trial node
            case 'trial'
                list = {'create new trialframe' 'delete current trial' 'duplicate current trial'};
                set(mainfigure.listBox,'String',list);
                
                %get current experiment object
                currentExperiment = getappdata(mainfigure.interfacewindow,'currentExperiment');
                currentNode = getappdata(mainfigure.interfacewindow,'selectedNode');
        
                %set table of property names and values
                trialTableSrc = currentExperiment.getCondition(currentNode.getParent.getParent.getName).getBlock(currentNode.getParent.getName).getTrial(currentNode.getName);
                dataforTable = trialTableSrc.getPropertyStrcuture;
                dataforTable = struct2cell(dataforTable);
                [mtable,buttons] = createTable(mainfigure.trialstimuliPanel,{'Property', 'Value'} , dataforTable,false,'AutoResizeMode',javax.swing.JTable.AUTO_RESIZE_ALL_COLUMNS,'Buttons','off');                                               
                jtable = mtable.getTable;
                cb = javax.swing.JComboBox({'First','Last'}); cb.setEditable(true);  % prepare an editable drop-down CellEditor
                editor = javax.swing.DefaultCellEditor(cb);
                jtable.getColumnModel.getColumn(1).setCellEditor(editor);  % assign this editor to second column (see Note 2)
                %trial frame node
            case num2cell(400:500)
                list = {'select trial stimuli' 'invert trial (negative)' 'set trial image positions (other than centered)' 'merge mutiple image files (must be of the same size)' 'delete current trialframe'};
                
                %initialize GUI
                set(mainfigure.listBox,'String',list);
                set(mainfigure.imageListBox,'enable','on'); %intentionally left enabled in order to ensure ease of use after initial reaching of this stage.
        end
        else
            disp('awaiting user action');
        end
    end

% file directory listing
    function load_listbox(pwd)
        dir_struct = dir(pwd);
        [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        
        handles.file_names = sorted_names;
        handles.is_dir = [dir_struct.isdir];
        handles.sorted_index = sorted_index;
        
        setappdata(mainfigure.imageListBox,'handles',handles)
        
        set(mainfigure.imageListBox,'String',handles.file_names,...
            'Value',1)
    end
%% user selections (actions)
    function listSelection(src,eventData,handles)
        selectionIndex = get(mainfigure.listBox,'value');
        listBoxOptions = get(mainfigure.listBox,'String');
        handleforfigure = guihandles;
        %get the text of the selected option
        selectedString = listBoxOptions{selectionIndex};
        %         get(handleforfigure.main_figure,'SelectionType')
        
        %get current experiment object
        currentExperiment = getappdata(mainfigure.interfacewindow,'currentExperiment');
        %get current selected node (required to add nodes to the tree and
        %update it according to hierarchy)
        currentNode = getappdata(mainfigure.interfacewindow,'selectedNode');
        %get the experiment tree
        %         treeH = currentExperiment.objectTree;
        
        % If double click
        if strcmp(get(handleforfigure.main_figure,'SelectionType'),'open')
            %do something
            switch selectedString
                %create a new condition within the experiment
                case 'create new condition'
                    disp('creating a new condition');
                    %create a new condition object
                    name = inputdlg('Please enter condition name','New Condition...');
                    %create object
                    newCondition = Condition(name);
                    %attach object to experiment object
                    result = currentExperiment.addCondition(newCondition);
                    %create a new node representing the new condition
%                    %get the number of existing conditions
%                     numofconds = size(currentExperiment.conditions,2);
                    if result
                    newCond = uitreenode('v0',newCondition.getID,name,'.\icons\condition.png',false);
                    currentNode.add(newCond);
                    
                    %draw the changes
                    TreeH.reloadNode(currentNode);
                    
                    %add to object index (tree2object)
                    end
                case 'create new block'
                    %create a new block within the current condition
                    name = inputdlg('please enter block name','New Block...');
                    %create block object
                    newBlock = Block(name);
                    
                    %attach object to experiment condition object
                    %get access to the new experiment object, then to the
                    %required condition and attach the new block to it.
                    currentCondition = currentExperiment.getCondition(currentNode.getValue);
                    currentCondition.addBlock(newBlock);
                    
                    %add to _master_ object table
                    currentExperiment.objectTable.addObj(newBlock.getID,'block');
                    %tbd - set parent condition of blcok ***
                    
                    
                    %add block to condition node
%                     numofblocks = size(currentCondition.blocks,2);
                    newBlockNode = uitreenode('v0',newBlock.getID,name,'.\icons\block.png',false);
                    currentNode.add(newBlockNode);
                    
                    TreeH.reloadNode(currentNode);
                    
                    
                case 'create new trial (Manual)'
                    %create a new trial within the current condition
                    name = inputdlg('please enter trial name','New Trial..');
                    %create block object
                    newTrial = Trial(name);
                    
                    %attach object to experiment condition object
                    %get access to the new experiment object, then to the
                    %required condition and attach the new block to it.
                    currentBlock = currentExperiment.getCondition(currentNode.getParent.getName).getBlock(currentNode.getName);
                    currentBlock.addTrial(newTrial);
                    
                    %tbd - set parent condition of blcok ***
                    
                    
                    %add block to condition node
                    numoftrials = size(currentBlock.trials,2);
                    newTrialNode = uitreenode('v0',300+numoftrials+1,name,'.\icons\trial.png',false);
                    currentNode.add(newTrialNode);
                    
                    TreeH.reloadNode(currentNode);
                 
                case 'create trials Wizard'     
                    %open a new GUI window and use all the wanted
                    %trialFrames (JPGs) - then, add rules - restrictions /
                    %requirements. TBD
                    trialsObject = trialWizardGUI();
                    
                case 'create new trialframe'   %stopped here
                    %create a new trialFrame within the current condition
                    name = inputdlg('please enter trial frame name','New Trial Frame..');
                    %create block object
                    newTrialFrame = TrialFrame(name);
                    
                    %attach object to experiment condition object
                    %get access to the new experiment object, then to the
                    %required condition and attach the new block to it.
                    % order : experiment -> (trial parent = block parent =
                    % condition ) -> (trial parent = block parent) -> get
                    % the trial itself
                    currentTrial = currentExperiment.getCondition(currentNode.getParent.getParent.getName).getBlock(currentNode.getParent.getName).getTrial(currentNode.getName);
                    currentTrial.addTrialFrame(newTrialFrame);
                    
                    %tbd - set parent condition of blcok ***
                    
                    %add to node
                    numoftrialframes = size(currentTrial.trialFrames,2);
                    newTrialFrameNode = uitreenode('v0',400+numoftrialframes+1,name,'.\icons\trialFrame.png',false);
                    currentNode.add(newTrialFrameNode);
                    
                    TreeH.reloadNode(currentNode);
                    
                case 'select trial stimuli(s)'
                    
                    set(mainfigure.imageListBox,'visible','on');
                    
                    %create a new trialFrame within the current condition
                    newStimuli
                    %for each image selected create a stimuli object
                    %(based on the image)
                                        
                    %attach object to experiment condition object
                    %get access to the new experiment object, then to the
                    %required condition and attach the new block to it.
                    % order : experiment -> (trial parent = block parent =
                    % condition ) -> (trial parent = block parent) -> get
                    % the trial itself
                    currentTrialFrame = currentExperiment.getCondition(currentNode.getParent.getParent.getName).getBlock(currentNode.getParent.getName).getTrial(currentNode.getParent.getName).getTrialFrame(currentNode.getName);
                    currentTrialFrame.addStimuli(newStimuli);
                    
                    %tbd - set parent condition of blcok ***
                    
                    %add to node
                    numoftrialframes = numel(currentTrial.trialFrames);
                    newTrialFrameNode = uitreenode('v0',400+numoftrialframes+1,name,'.\icons\trialFrame.png',false);
                    currentNode.add(newTrialFrameNode);
                    
                    TreeH.reloadNode(currentNode);
                    
                case 'invert trial (negative)'
                    %create a negative
                    index_selected = get(mainfigure.imageListBox,'Value');
                    file_list = get(mainfigure.imageListBox,'String');
                    filename = file_list{index_selected};
                    %read original image
                    originalImage = imread(filename);
                    %invert the image using image processing toolbox
                    invertedImage = imcomplement(originalImage);
                    %save-output-file
                    [path,name,ext] = fileparts(filename);
                    ext = ext(2:end);
                    imwrite(invertedImage,[name,'_inv.',ext],ext);
                    load_listbox(pwd);
                    
                case 'delete current condition'
                    %change actual data structure - delete condition from the experiment
                    
                    nameOfNode = getappdata(mainfigure.interfacewindow,'selectedNode'); 
                    nameOfCondition = nameOfNode.getName;
                    
                    currentExperiment.removeCondition(nameOfCondition);
                    
                    %alter the uitree - graphical representation
                    deleteCurrentNode;
                    
                case 'delete current block'
                    %change data structure
                    %find current block within current condition
                    nameOfNode = getappdata(mainfigure.interfacewindow,'selectedNode'); 
                    nameOfParent = nameOfNode.getParent;
                    nameOfCondition = nameOfParent.getName;
                    nameOfBlock = nameOfNode.getName;
                    
                    %alter the uitree - graphical representation
                    deleteCurrentNode;
                case 'delete current trial'
                    deleteCurrentNode;
                case 'delete current trialframe'
                    deleteCurrentNode;
            end
        else
            %currently nothing
        end
    end

    function deleteCurrentNode()
       currentNode = getappdata(mainfigure.interfacewindow,'selectedNode'); 
                   parentofNode = currentNode.getParent;
                   TreeH.remove(currentNode);
                   TreeH.reloadNode(parentofNode); 
    end

    function imageListSelection(hObject,eventData)
        handleforfigure = guihandles;
        % if error use the imagelistbox tag
        index_selected = get(mainfigure.imageListBox,'Value');
        file_list = get(mainfigure.imageListBox,'String');
        filename = file_list{index_selected};
        
        if strcmp(get(handleforfigure.main_figure,'SelectionType'),'open')
            %what to do if an open folder was selected
            if  handles.is_dir(handles.sorted_index(index_selected))
                cd (filename)
                load_listbox(pwd)
            else %what to do if a file was selected for opening
                [path,name,ext] = fileparts(filename);
                switch ext
                    case '.exp'
                        disp('opening experiment file');
                        button = questdlg('Are you sure you want to open this experiment and discard changes?','Open experiment file','Yes','No','No');
                        load_experiment(filename); %tbd
                    case {'.JPG' , '.jpeg', '.gif', '.jpg', '.GIF','.png'}
                        imtool(filename);
                        % add the code relevant once this is an image and
                        % we're creating a stimuli
                        
                    otherwise
                        %                 try
                        %                     open(filename)
                        %                 catch ex
                        %                     errordlg(...
                        %                       ex.getReport('basic'),'File Type Error','modal')
                        %                 end
                        %                         errordlg('Not an experiment file!');
                end
            end
        else % if a single click was made
            disp('single click - relative to preview only');
            %lets use the events and notifiers concept here - as proof of
            %concept :)
            %notify the image viewer pane - with the selected image
            [path,name,ext] = fileparts(filename);
            switch ext
                case {'.jpg' '.JPG' '.JPEG' '.jpeg' '.gif' '.GIF' '.png' '.PNG'}
                    updateImage(filename);
            end
        end
    end

%% save the experiment
    function saveExperiment(src,event,mainfigure,treeH)
        %create an .exp file
        %put the current tree structure into the experiment for future
        %design updates and viewing.
       currentExperiment = getappdata(mainfigure.interfacewindow,'currentExperiment');
       currentExperiment.objectTree = treeH;
       %save into our 'propriatery' format 
       save([currentExperiment.name,'.exp'],'currentExperiment');
        
    end

%% timeline plot callback functions
% Subfuntions implementing the two callbacks
% ------------------------------------------

    function plot_callback(hObject, eventdata, column)
    % hObject     Handle to Plot menu
    % eventdata   Not used
    % column      Number of column to plot or clear

    colors = {'b','m','r'}; % Use consistent color for lines
    colnames = get(htable, 'ColumnName');
    colname = colnames{column};
    if get(hObject, 'Value')
        % Turn off the advisory text; it never comes back
        set(hprompt, 'Visible', 'off')
        % Obtain the data for that column
        ydata = get(htable, 'Data');
        set(haxes, 'NextPlot', 'Add')
        % Draw the line plot for column
        plot(haxes, ydata(:,column),...
            'DisplayName', colname,...
            'Color', colors{column});
    else % Adding a line to the plot
        % Find the lineseries object and delete it
        delete(findobj(haxes, 'DisplayName', colname))
    end
    end


    function select_callback(hObject, eventdata)
    % hObject    Handle to uitable1 (see GCBO)
    % eventdata  Currently selected table indices
    % Callback to erase and replot markers, showing only those
    % corresponding to user-selected cells in table. 
    % Repeatedly called while user drags across cells of the uitable

        % hmkrs are handles to lines having markers only
        set(hmkrs, 'Visible', 'off') % turn them off to begin
        
        % Get the list of currently selected table cells
        sel = eventdata.Indices;     % Get selection indices (row, col)
                                     % Noncontiguous selections are ok
        selcols = unique(sel(:,2));  % Get all selected data col IDs
        table = get(hObject,'Data'); % Get copy of uitable data
        
        % Get vectors of x,y values for each column in the selection;
        for idx = 1:numel(selcols)
            col = selcols(idx);
            xvals = sel(:,1);
            xvals(sel(:,2) ~= col) = [];
            yvals = table(xvals, col)';
            % Create Z-vals = 1 in order to plot markers above lines
            zvals = col*ones(size(xvals));
            % Plot markers for xvals and yvals using a line object
            set(hmkrs(col), 'Visible', 'on',...
                            'XData', xvals,...
                            'YData', yvals,...
                            'ZData', zvals)
        end
    end
end


