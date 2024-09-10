function processMultipleVideos(options)
%
%   ardic.processMultipleVideos

%{
ardic.processMultipleVideos
%}

if nargin == 0
    options = ardic.video_processing_options;
end

selected_files = ardic.utils.fileSelectorGUI();
n_files = length(selected_files);
for i = 1:length(selected_files)
    cur_file_path = selected_files{i};
    [~,name]=fileparts(cur_file_path);
    

    temp = VideoReader(cur_file_path);
    n_frames_total = temp.NumFrames;
    clear temp

    fprintf('%d/%d: %s, %d frames\n',i,n_files,name,n_frames_total);
    ardic.processVideo(cur_file_path,options)
end


end