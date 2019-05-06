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
%           %%%    %%%          %%%%%%%%%   WRITEBYTESTREAM.M
%
%
%
% writes the header and datachunk to a file
%
% input:        outputfilename    - full path and name of the compressed file
%               height            - height of the image (or the representation)
%               width             - width of the iamge or the representation
%               compressiontype   - compression type
%               outputcolorformat - colorformat the image is actually in (to convert to RGB)
%               reserved1         - reserved variable (LLoyd-Max-Initialization,...)
%               reserved2         - reserved variable 2
%               bytestream        - contains the actually encoded image
%               verb              - if =0 no output messages are written 
%
%
% returnvalue:  success          - 0: some error occured
%                                - 1: bitstream written
%
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%
%-----------------------------------------------------------------------------------

function [success] = writeBitstream( outputfilename, height, width, compressiontype, outputcolorformat, reserved1, reserved2, bytestream, verb )

% load config file
load data/config.mat


% open file and check if everything's OK
fid = fopen(outputfilename,'w');                                 % open output file
if(fid<0)                                                        % file couldn't be opened
    disp('Couldn`t open output file !!!')
    success=0;                                                  
    return;                                                      % return with error indicated
end

count = fprintf(fid,'%s','IVCL');                                % write magic

% change this value if header is modified
count = count + 2*fwrite(fid,uint16(20),'uint16');               % headersize

count = count + fwrite(fid,uint8(compressiontype),'uchar');      % write compressiontype
count = count + fwrite(fid,uint8(outputcolorformat),'uchar');    % write colorformat of the encoded image

count = count + 2*fwrite(fid,uint16(height),'uint16');     % write height
count = count + 2*fwrite(fid,uint16(width),'uint16');      % write width

count = count + 4*fwrite(fid,reserved1,'float32');         % write reserved1 
count = count + 4*fwrite(fid,reserved2,'float32');         % write reserved2 
% TODO: add parameters here



headersize=count;

if(verb) fprintf('\nbytes written to "%s":\nHeader : %d',outputfilename,count);end;

count = count + fwrite(fid,bytestream,'uchar');        % write reserved1 (for later use)

if(verb) fprintf('\nData   : %d',count-headersize);
         fprintf('\nFile   : %d\n',count);
end;

fclose(fid);            % close file

success=1;
return;                 % return with success