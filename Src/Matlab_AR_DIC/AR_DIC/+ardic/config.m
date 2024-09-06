classdef config
    %
    %   Class:
    %   ardic.config
    %
    %   See Also
    %   --------
    %   ardic.user_config
    %   ardic.user_config_template

    properties
        s
    end

    methods
        function obj = config()
            %
            %   Load the user config

            if isempty(which('ardic.user_config'))
                error('user config must be specified, copy the user_config_template to user_config.m in the same folder and modify')
            end
            obj.s = ardic.user_config;
        end
        function path = getFFMpegPath(obj)
            %This works if the path is set
            [status,cmd_out] = system('where ffmpeg');
            cmd_out = strtrim(cmd_out);
            if exist(cmd_out,'file')
                path = cmd_out;
                return
            end
            if isfield(obj.s,'ffmpeg_root')
                root = obj.s.ffmpeg_root;
                path = fullfile(root,'ffmpeg.exe');
                %TODO: Disambiguate, test root first
                if ~exist(root,'file')
                    error('Specified ffmpeg root folder does not exist or ffmpeg.exe does not exist in it')
                end
            else
                error('user_config does not specify ffmpeg_root')
            end
            
        end
    end
end