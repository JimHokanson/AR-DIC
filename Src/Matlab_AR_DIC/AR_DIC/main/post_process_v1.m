% root = 'L:\Mitchell Lab\Mitchell\Common Lab\Cell Culture\siRNA HL\siRNA experiment 4';
root = 'C:\Users\jhokanson\Box\iPSC-CM videos HL';

[~,root_name] = fileparts(root);

d = dir(fullfile(root,'*DIC_results'));
n_videos = length(d);
max_displacement = zeros(n_videos,1);
max_velocity = zeros(n_videos,1);
for i = 1:n_videos
    
    DIC_folder = fullfile(root,d(i).name);
    fprintf('%d/%d: %s\n',i,n_videos,d(i).name)
    stringtext='*PIV3*.txt';% get only output files from 3rd iteration of plugin
    scale100=4.78; %set pixel micrometer scale px/um (10x objective)


    %****** JAH, big issue to look into ******
    %--------------------------------------------------
    temp = d(i).name;
    n_chars_back = length('_DIC_results');
    video_name_prefix = temp(1:end-n_chars_back);

    d2 = dir(fullfile(root,[video_name_prefix '*']));
    
    %Remove the folder
    d2 = d2(~[d2.isdir]);

    %TODO: Check that we only have 1 d2 object (the video)

    temp_video_obj = VideoReader(fullfile(root,d2.name));
    timestep = 1/temp_video_obj.FrameRate;

    % timestep=1/60; %set time between frames (seconds)

    threshold=0.07; %define threshold for threshold plot 0.14 from Fukuda et. al
    %plotting options:
    ncont=50; %number of contour levels in plots
    qscale=1; %quiver plot arrow scale
    mapstyle='parula'; %map color scheme or try gray
    strain_type='green_lagrangian'; % strain calculation to use. Options: 'green_lagrangian' or 'cauchy'
    tree_opt='convex_hull';%'box' for faster processing, 'convex_hull' for higher accuracy

    %Primary data processing occurs here:
    %initial data processing occurs in vidobj, (displacement, velocity, etc.):
    stretch2=vidobj(stringtext,DIC_folder, scale100,timestep); %process contracting
    max_displacement(i) = stretch2.max_disp;
    max_velocity(i) = stretch2.max_velocity;
end

name = string({d.name}');
root = repmat({root_name},n_videos,1);

t = table(root,name,max_displacement,max_velocity);

writetable(t,[root_name '.xlsx'])

