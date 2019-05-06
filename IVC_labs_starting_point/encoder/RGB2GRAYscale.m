%--------------------------------------------------------------
%
%
%
%           %%%    %%%       %%%      %%%%%%%%
%           %%%    %%%      %%%     %%%%%%%%%            
%           %%%    %%%     %%%    %%%%
%           %%%    %%%    %%%    %%%
%           %%%    %%%   %%%    %%%
%           %%%    %%%  %%%    %%%
%           %%%    %%% %%%    %%%
%           %%%    %%%%%%    %%%
%           %%%    %%%%%     %%% 
%           %%%    %%%%       %%%%%%%%%%%%
%           %%%    %%%          %%%%%%%%%   RESIZEIMAGE.M
%
%
% performs an RGB to grayscale transformation on the image
%
% input:       imageRGB     - input image in RGB format
%
% output:      iimageGRAY) is the luminace component as a 2D matrix 
%
%
% Course:      Image and Video Compression
%              Prof. Eckehard Steinbach
%
% Author:      Dipl.-Ing. Ingo Bauermann 
%              02.01.2003 (created)
%
%-----------------------------------------------------------------------------------

function [imageGRAY] = RGB2GRAYscale(imageRGB)

imageGRAY=.2125*imageRGB(:,:,1)+.7154*imageRGB(:,:,2)+.0721*imageRGB(:,:,3);    % perform RGB to grayscale conversion
return;                                                                         % return to caller