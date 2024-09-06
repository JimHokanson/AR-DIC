function MIJ_DIC(folderpath,vidpath,refframe,currentframe,option_string)
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

%????? What is the reference frame?

s = struct;
t = tic;
MIJ.run('AVI...', ['open=[',vidpath,'] first=',num2str(refframe),' last=' num2str(refframe)]); %open current reference frame
s.s1 = toc(t);
t = tic;
MIJ.run('8-bit'); %convert to 8bit for plugin use
s.s2 = toc(t);
t = tic;
MIJ.run('AVI...', ['open=[',vidpath,'] first=',num2str(currentframe),' last=' num2str(currentframe)]);% open frame to analyze
s.s3 = toc(t);

t = tic;
MIJ.run('8-bit'); %convert to 8bit for plugin use
s.s4 = toc(t);

t = tic;
MIJ.run('Images to Stack',['name=(',num2str(refframe),',',num2str(currentframe),')']); %make image stack (reference frame, current frame) for plugin use
s.s5 = toc(t);
%run iterative PIV plugin:
t = tic;
MIJ.run('iterative PIV(Advanced)...', ['  ',option_string,' batch path=[',folderpath,']']);
s.s6 = toc(t);

t = tic;
MIJ.run('Close All');%close all ImageJ images
s.s7 = toc(t);

s