function trailWizardGUI()
%this function lets the user add all the required JPGs (stimuli) and
%create all the combinations for the experiment.
%the result: an array containing trials with stimuli

%since every experiment might have different properties (features and
%fields) - the generator will create all the possible / required
%permutations and export the data to excel in order to import it along
%with the data fields required by the user.

%if this is not well understood by the description - pls take a look at
%the screencast in this link :
% TBD

interface.mainFigure = figure('Visible','on',...
    'Units','normalized',...
    'Tag', 'main_figure',...
    'Position',[0.1, 0.2, 0.75, 0.6],...
    'MenuBar','none',...
    'Name','Trial Creation Wizard',...
    'Resize','off',...
    'Toolbar','none',...
    'NumberTitle','off',...
    'DockControls','off',...
    'Color','white',...
    'CloseRequestFcn',@close_main_interface);

    %intercace elements: 
    %a. table containing all the possible combinations once the input is
    %done
    %b. create new "law" table (columnds - type,pattern,indices
    %c. selection of JPGs to incorporate into the trailFrames
    %export the combinations to excel in order for the user to add columns
    %that represent the fields. 

    %main difference from the current "though" process - in the raw data
    %format the trialFrames will refer to JPGs by path. (relative
    %pathnames)
    

    
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

    
    function close_main_interface(~,~)
        delete(interface.mainFigure);
    end


end