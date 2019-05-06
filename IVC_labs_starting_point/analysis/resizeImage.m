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
% resizes an image to an arbitrary spatial resolution
%
%
% input:        inputimage      - the image to be resized
%               to_height       - height after resizing
%               to_width        - width after resizing
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%
%-----------------------------------------------------------------------------------

function [imageRES] = resizeImage(inputimage, to_height, to_width)

[from_height from_width dimensions] = size(inputimage);             % get old dimensions

imageRES(:,:,1) = resample(resample(inputimage(:,:,1),to_height,from_height,3)',to_width,from_width,3)';
imageRES(:,:,2) = resample(resample(inputimage(:,:,2),to_height,from_height,3)',to_width,from_width,3)';
imageRES(:,:,3) = resample(resample(inputimage(:,:,3),to_height,from_height,3)',to_width,from_width,3)';

imageRES = max(min(imageRES,1),0);    

    