function selectedFiles = fileSelectorGUI()
    %
    %   
    %   selectedFiles = ardic.utils.fileSelectorGUI();
    %
    %   This is nearly verbatim from chatGPT. Well, I added a few things
    %   but maybe 90% is chatGPT.
    %
    %   Improvements
    %   -------------
    %   1. allow passing in the file filter

    VIDEO_FORMAT = {'*.MOV;*.AVI','video files'};

    % Create the main figure window
    hFig = figure('Position', [400, 300, 600, 600], 'MenuBar', 'none', ...
                  'Name', 'File Selector', 'NumberTitle', 'off', ...
                  'Resize', 'on', 'CloseRequestFcn', @closeGUI);
    hFig.ResizeFcn = @resizeUI;

    % Create the listbox to display selected files
    hListbox = uicontrol('Style', 'listbox', 'Position', [20, 70, 360, 180], ...
                         'Max', 2, 'Min', 0,'FontSize',12);

    % Add button to allow users to add more files
    hAddButton = uicontrol('Style', 'pushbutton', 'String', 'Add', ...
                           'Position', [20, 20, 100, 30], ...
                           'Callback', @addFiles);

    % Remove button to allow users to remove selected files
    hRemoveButton = uicontrol('Style', 'pushbutton', 'String', 'Remove', ...
                              'Position', [150, 20, 100, 30], ...
                              'Callback', @removeFiles);

    % Done button to close the GUI and return the selected files
    hDoneButton = uicontrol('Style', 'pushbutton', 'String', 'Done', ...
                            'Position', [280, 20, 100, 30], ...
                            'Callback', @doneSelection);

    % Initialize a cell array to hold selected file paths
    selectedFiles = {};

    resizeUI(1,1)

    % Callback function to add files to the list
    function addFiles(~, ~)
        [filenames, filepath] = uigetfile(VIDEO_FORMAT, 'Select Files', 'MultiSelect', 'on');
        if iscell(filenames)
            newFiles = strcat(filepath, filenames);
            selectedFiles = [selectedFiles; newFiles(:)]; % Append new files to the list
        elseif ischar(filenames)
            selectedFiles = [selectedFiles; fullfile(filepath, filenames)];
        end
        selectedFiles = unique(selectedFiles,'stable');
        updateList();
    end

    % Callback function to remove selected files from the list
    function removeFiles(~, ~)
        selectedIdx = get(hListbox, 'Value');
        if ~isempty(selectedIdx)
            selectedFiles(selectedIdx) = [];
            updateList();
        end
    end

    % Resize callback to adjust the positions of UI elements
    function resizeUI(~, ~)
        figPos = get(hFig, 'Position'); % Get the new figure size
        set(hListbox, 'Position', [20, 70, figPos(3)-40, figPos(4)-100]); % Resize the listbox
        set(hAddButton, 'Position', [20, 20, 100, 30]); % Keep the Add button fixed
        set(hRemoveButton, 'Position', [150, 20, 100, 30]); % Keep the Remove button fixed
        set(hDoneButton, 'Position', [figPos(3)-120, 20, 100, 30]); % Adjust Done button position
    end

    % Callback function to close the GUI and return the selected files
    function doneSelection(~, ~)
        uiresume(hFig); % Resume the UI after Done button is clicked
        delete(hFig); % Close the figure window
    end

    % Callback function to close the GUI
    function closeGUI(~, ~)
        selectedFiles = {}; %Treat this as a cancel
        uiresume(hFig);
        delete(hFig); % Close the figure window
    end

    % Function to update the listbox display with current files
    function updateList()
        n_files = length(selectedFiles);
        numeric_strings = string(1:n_files)';
        display_strings = cellfun(@(x,y) sprintf('%s) %s',x,y),...
            numeric_strings,selectedFiles,'un',0);


        set(hListbox, 'String', display_strings, 'Value', []); % Reset listbox selection
    end

    uiwait(hFig); % Wait until the figure is closed
end