classdef video_processing_options < handle
    %
    %   Class:
    %   ardic.video_processing_options

    properties
        %If specified, put things in that folder
        video_save_root

        start_frame = 1
        end_frame
        %fro - frobenius norm
        %ent - entropy
        ref_method = 'fro'

        %frame becomes new reference if score is below norm threshold
        norm_threshold = 1.5;

        verbose = false
    end

    methods
        function obj = video_processing_options()
        end
        function root = getVideoSaveRoot(obj,video_path)
            [video_root,file_name] = fileparts(video_path);
            %Could have DIC_results first ...
            folder_name = [file_name '_DIC_results'];
            if isempty(obj.video_save_root)
                root = fullfile(video_root,folder_name);
            else
                root = fullfile(obj.video_save_root,folder_name);
            end
            if ~exist(root,'dir')
                mkdir(root)
            end
        end
        function end_frame = getEndFrame(obj,n_frames_video)
            if isempty(obj.end_frame)
                end_frame = n_frames_video;
            else
                if obj.end_frame > n_frames_video
                    end_frame = n_frames_video;
                else
                    end_frame = obj.end_frame;
                end
            end
        end
    end
end