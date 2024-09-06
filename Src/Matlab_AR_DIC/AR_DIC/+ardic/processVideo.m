function processVideo(video_path,options)
%
%   ardic.processVideo(video_path)
%
%
%   Improvements
%   ------------
%   - add support for verbose printing
%   - add PIV loop printing
%   - expose processing options
%       - move to config?
%           - no, needs to be tracked
%   - fix loading ref score - loading of last frame
%       - test starting in the middle of a video

%{
    video_path = 'D:\Data\aoy\videos\137P31 ASO_1.MOV';
    options = ardic.video_processing_options;
    options.end_frame = 3;
    ardic.processVideo(video_path,options)
%}

if nargin == 1
    options = ardic.video_processing_options;
end

%Ideally these would be exposed as options ...
option_string='piv1=128 sw1=256 vs1=64 piv2=64 sw2=128 vs2=32 piv3=48 sw3=96 vs3=24 correlation=0.8';


%Step 1:
%-----------------------------------
%Do conversion if necessary
video_converted = false;
[~,video_file_name,ext] = fileparts(video_path);
if ~strcmpi(ext,'avi')
    video_converted = true;
    config = ardic.config();
    ffmpeg_path = config.getFFMpegPath();
    %ffmpeg -i "137P31 ASO_1.MOV" -c:v rawvideo "137P31 ASO_1.AVI"
    video_path = fullfile(cd,'temp_ardic.avi');
    if exist(video_path,'file')
        delete(video_path)
    end
    cmd = sprintf('%s -i "%s" -c:v rawvideo "temp_ardic.avi"',ffmpeg_path,video_path);
    fprintf('Converting file to AVI: %s\n',video_file_name)
    [status,result] = system(cmd); %#ok<ASGLU>
    if ~exist(video_path,'file')
        error('ffmpeg failed to create converted file -- not sure why ...')
    end
    fprintf('Conversion finished\n')
end

temp = VideoReader(video_path);
n_frames_total = temp.NumFrames;

%To avoid backslash issues in ImageJ
video_path_imagej = video_path;
video_path_imagej = strrep(video_path_imagej,'\','/');

%Step 2:
%------------------------------------
%Compute the PIV results
dic_save_root = options.getVideoSaveRoot(video_path);
path_query = fullfile(dic_save_root,'*PIV3*.txt'); 
dic_save_path_imagej = strrep(dic_save_root,'\','/');
if dic_save_path_imagej(end) ~= '/'
    %For some reason the PIV code strips the last
    %folder if not ending with '\\' or '/'
    dic_save_path_imagej = [dic_save_path_imagej '/'];
end

%initialize, start MIJ without gui
fprintf('Initializing MIJ\n')
Miji(false);

start_frame=options.start_frame;
ref_frame = start_frame;
end_frame = options.getEndFrame(n_frames_total);

score_keeper = NaN(end_frame,1);
is_ref_frame = false(end_frame,1);
is_ref_frame(start_frame) = true;

fprintf('Processing started\n')
for current_frame = start_frame+1:end_frame
    
    %Perform DIC in ImageJ
    %--------------------------------
    h__MIJ_DIC(dic_save_path_imagej,video_path_imagej,ref_frame,current_frame,option_string);

    %Adaptive Reference portion:
    %---------------------------
    dispmag = h__DIC_disp(path_query);

    %calculate reference score of current frame
    ref_score = h__calcrefscore(dispmag,options.ref_method);

    score_keeper(current_frame) = ref_score;
    %If reference score is below norm threshold then set current frame as reference
    if ref_score < options.norm_threshold
        ref_frame = current_frame; %set current frame as reference
        is_ref_frame(current_frame) = true;
    end
end

dic_summary_file_path = fullfile(dic_save_root,['DIC_results_' video_file_name '.mat']);
save(dic_summary_file_path,'score_keeper','ref_score')


%Clears the "Results" window so no prompt for saving when closing
MIJ.run("Clear Results")
MIJ.closeAllWindows

MIJ.exit;
if video_converted
    [~,name] = fileparts(video_path);
    %Double checking, don't want to delete good files
    if name == "temp_ardic.avi"
        delete(video_path)
    else
        error('Jim has an error in his code')
    end
end

% % % %%
% % % figure %plot reference score versus frame
% % % plot(score_keeper)%plot reference scores
% % % hold on
% % % scatter(refstore-1,zeros(1,length(refstore))); %mark reference frames
% % % %EOF

end

function refscore = h__calcrefscore(disp_mat,ref_method)
% CALCREFSCORE Calculates reference frame score from displacement matrix.
%
% Usage: refscore=calcrefscore(disp_mat,refmethod)
%
% Inputs: disp_mat, nxm displacement array. refmethod (string) specifies
% the scoring method. 'fro' uses the frobenius norm and 'ent' uses the
% entropy.
%
% Returns: score value refscore (scalar).
% 
% Adaptive Reference Digital Image Correlation v 1.0 2018
% Biomaterials and Mechanotransduction Lab University of Nebraska-Lincoln

switch ref_method
    case 'fro'
       refscore=norm(disp_mat,'fro');%frobenius norm
    case 'ent'
       refscore=entropy(disp_mat); %entropy
    otherwise
        error('Unrecognized ref score option: %s',ref_method)
end

end


function dispmag = h__DIC_disp(stringtext)
% DIC_DISP Calculates displacement magnitude from highest numerical DIC filename in directory.
%
% Usage: dispmag=DIC_disp(stringtext)
%
% Inputs: stringtext (string) specifies the text to search for to input DIC
% files.
%
% Returns: dispmag (array) containing displacement values from most recent
% DIC iteration.
%
% Adaptive Reference Digital Image Correlation v 1.0 2018
% Biomaterials and Mechanotransduction Lab University of Nebraska-Lincoln
%
% See also:
% MIJ_DIC
% VIDOBJ
% READIMAGEJPIV

%TODO: We should know the frame, no need to do natural sort


PIVtext = dir(stringtext);%get text file list
PIVtext_names={PIVtext.name};%get file names

%Call to a function - move local (or remove, see note above)
[~,idx] = sort_nat(PIVtext_names);%get sorting index

PIVtext = PIVtext(idx);%sort files in alphanumerical order
d = PIVtext(end);
file_path = fullfile(d.folder,d.name);
M = dlmread(file_path); %read in text file from ImageJ PIV
dispmag = M(:,5); %transfer data to individual vectors for coordinates

end

function h__MIJ_DIC(folderpath,vidpath,refframe,currentframe,option_string)
% MIJ_DIC Passes commands to ImageJ for performing digital image correlation
%
% Usage: MIJ_DIC(folderpath,vidpath,refframe,currentframe,option_string)
%
% Input: folderpath (string) path of folder to save DIC files to. vidpath
% (string) path to input video. refframe (scalar) video frame to use as
% reference frame. currentframe (scalar) current video frame to evaluate.
% option_string (string) containing setup parameters for ImageJ iterative
% PIV(Advanced) plugin. Example option_string:
% 'piv1=128 sw1=256 vs1=64 piv2=64 sw2=128 vs2=32 piv3=48 sw3=96 vs3=24 correlation=0.8'
%
% Adaptive Reference Digital Image Correlation v 1.0 2018
% Biomaterials and Mechanotransduction Lab University of Nebraska-Lincoln
%
% See also:
% READIMAGEJPIV

MIJ.run('AVI...', ['open=[',vidpath,'] first=',num2str(refframe),' last=' num2str(refframe)]); %open current reference frame

MIJ.run('8-bit'); %convert to 8bit for plugin use

MIJ.run('AVI...', ['open=[',vidpath,'] first=',num2str(currentframe),' last=' num2str(currentframe)]);% open frame to analyze

MIJ.run('8-bit'); %convert to 8bit for plugin use

MIJ.run('Images to Stack',['name=(',num2str(refframe),',',num2str(currentframe),')']); %make image stack (reference frame, current frame) for plugin use

%run iterative PIV plugin:
%
%   This is what takes forever to run and could be rewritten to do in
%   parallel
MIJ.run('iterative PIV(Advanced)...', ['  ',option_string,' batch path=[',folderpath,']']);

MIJ.run('Close All');%close all ImageJ images

end