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
%           %%%    %%%          %%%%%%%%%   READBITSTREAM.M
%
%
% description: encode organises the encoding process of the image
%
% input:        inputfilename     - full path and name of the file to be decompressed
%
% returnvalue:  height            - height of the image
%               width             - width of the image
%               compressiontype   - compression mode that is to be used
%               outputcolorformat - representation color format (to convert to RGB)
%               reserved1         - reserved1 additional variable
%               reserved2         - reserved1 additional variable
%               bytestream        - vector containing 8-bit integers that represent the compressed image
%               success           - =1 if the file could be opened, =0 otherwise
%           
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%
%-----------------------------------------------------------------------------------

function [height, width, compressiontype, outputcolorformat, reserved1, reserved2, bytestream, success] = readBitstream( inputfilename )

% load config file
load data/config.mat

% open file
fid = fopen(inputfilename);             % open bitstream
if(fid<0)                               % no valid file descriptor -> error
    disp('Could`n open output file -> Exit!');
    success=0;                          % indicate that an error has occurred
    return;                             % return to caller
end


fid = fopen(inputfilename);             % open compressed file
magic=fread(fid,4,'uchar');             % read the testimage
if(strcmpi(magic,'IVC0'))               % compare magic
    if(verb) fprintf('IVC0-Format recognized...');end;
end;

headersize=fread(fid,1,'uint16');       % get headersize
compressiontype=fread(fid,1,'uint8');   % get compressiontype
outputcolorformat=fread(fid,1,'uint8'); % get colorformat
height=fread(fid,1,'uint16');           % get height of image
width=fread(fid,1,'uint16');            % get width of image

reserved1=fread(fid,1,'float32');       % get reserved1
reserved2=fread(fid,1,'float32');       % get reserved2

bytestream=double(fread(fid,inf,'uint8'));  % get the bit/bytestream

fclose(fid);                            % close file

success=1;                              % nothing went wrong
return;                                 % return to decoder