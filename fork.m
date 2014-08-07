

% exp = Experiment('newexp')
% cond1 = Condition('cond1')
% cond2 = Condition('cond2')
% 
% exp.addCondition(cond1)
% exp.addCondition(cond2)

%=====================================================================
% Load up the listbox, lstImageList, with image files 
% in the folder handles.CalibrationFolder.
function fork
function handles = LoadImageList(handles)
try	
	% Get the folder into a handy variable name.
	% (Change handles.CalibrationFolder as needed for your situation.)
	folder = handles.CalibrationFolder;
	
	% Check that the folder actually exists.
	if ~isempty(folder)
		% Folder is not empty.  There is actually some text in it.
		if ~exist(folder,'dir')
			% Folder does not exist on disk.
			WarnUser(['Folder ' folder ' does not exist.']);
			return;
		end
	else
		% Folder is empty/null.
		WarnUser('ERROR: No folder specified as input for function LoadImageList.');
		return;
	end
	% If it gets to here, the folder exists.

	% Get a list of all files in the folder.
	filePattern = fullfile(folder, '/*.*');
	ImageFiles = dir(filePattern);
	
	% Filter the list to pick out only files of
	% file types that we want (image and video files).
	ListOfImageNames = {}; % Initialize
	for Index = 1:length(ImageFiles)
		% Get the base filename and extension.
		baseFileName = ImageFiles(Index).name;
		[folder, name, extension] = fileparts(baseFileName);
		% Examine extensions for ones we want.
		extension = upper(extension);
		switch lower(extension)
			case {'.png', '.bmp', '.jpg', '.tif', '.avi'}
				% Keep only PNG, BMP, JPG, TIF, or AVI image files.
				ListOfImageNames = [ListOfImageNames baseFileName];
	%         otherwise
		end
	end
	% Now we have a list of validated filenames that we want.
	% Send the list of validated filenames to the listbox.
	set(handles.lstImageList, 'string', ListOfImageNames);
	
catch ME
	% Alert the user of the error.
	errorMessage = sprintf('Error in LoadImageList().\nThe error reported by MATLAB is:\n\n%s', ME.message);
	WarnUser(errorMessage); % WarnUser code is uiwait(warndlg(errorMessage));
	% Print the error message out to a static text on the GUI.
	set(handles.txtInfo, 'String', errorMessage);
end
return; % from LoadImageList()

%--------------------------------
function WarnUser(warningMessage)
	uiwait(warndlg(warningMessage));
	return; % from WarnUser()
end
end
end