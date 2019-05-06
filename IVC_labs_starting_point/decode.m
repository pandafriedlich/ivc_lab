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
%           %%%    %%%          %%%%%%%%%   DECODE.M
%
%
% description: decode organises the decoding process of the bitstream
%
% input:        akset            - number of Set used (defined in config.m)
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

function [success] = decode( akSet )

load data/config.mat            % load offline Parameters

inputfilename   = ParameterStruct( akSet ).output_stream_filename;
outputfilename  = ParameterStruct( akSet ).reconstructed_image_filename;
verb            = ParameterStruct( akSet ).verbose;

path(path,'encoder')            % make the encoder-functions visible to matlab
path(path,'decoder')            % make the decoder-functions visible to matlab


imagetype=ID_RGB;               % standard colorspace

%---------------------------------
% read stream
%---------------------------------

if(verb) fprintf('\n\n-----------------------------------\n- DECODING\n\nReading stream...\n');end;                                                % show message if verbose mode is on 
[height width compressionID outputcolorID reserved1 reserved2 bytestream success]=readBitstream(inputfilename); % parse header and get bytestream
if(success==0) 
    disp('Couldn''t read file! -> Exit!');
    return;
end;

%----------------------------------
% decompress image
%----------------------------------

if( outputcolorID == ID_grayscale )                                 % check if this is a one component image
    switch lower( compressionID )                                   % test for compression type
        case ( ID_nocompression )                                   % if no compression should be applied -> nothing has to be done 
            if(verb) disp('Decompressing grayscale-image...');end;  
            imageCONV = reshape( bytestream, height, width, 1 ) / 256;
        
        case ( ID_omit )
            imageCONV = 0;                              % store nothing            
            
        otherwise
            fprintf('Not yet implemented (ID): %s', compressionID );
            success = 0;
            return;
    end;
else                                                    % three component compression type
    switch compressionID                                % test for compression type
        case ( ID_nocompression )                       % if no compression should be applied -> nothing has to be done  
            if( verb ) disp('Decompressing color-image...'); end;  
            imageCONV = reshape( bytestream, height, width,3 ) / 256.0;           

            %-------------------------------------
            %   Add decompression-schemes here
            %-------------------------------------            
              
        otherwise
            disp('Not yet implemented:');
            disp( compressionID );
            success = 0;
            return;
    end;    
end;
        

%---------------------------------
% back conversion to RGB
%---------------------------------

switch outputcolorID                                               % perform conversion on input image
    case ( ID_grayscale )                                          % image is converted to grayscale mode for further processing
        if( verb ) disp('Converting grayscale to RGB...'); end;    % show message if verbose mode is on
        imageRGB( :, :, 1) = imageCONV( :, :);
        imageRGB( :, :, 2) = imageCONV( :, :);
        imageRGB( :, :, 3) = imageCONV( :, :);
        imagetype = ID_RGB;                                   % set grayscale-type for further processing
        
    case ( ID_RGB )                                           % image is converted to RGB mode for further processing
        if( verb ) disp( 'RGB image detected...' ); end;      % show message if verbose mode is on
        imageRGB = imageCONV;                                 % just copy RGB to RGB
        imagetype = ID_RGB;                                   % set RGB-type for further processing
     
        
    %------------------------    
    % ADD new formats here
    %------------------------       
        
        
    otherwise                                               % error !!!
        disp('Input-colorformat not valid - exiting');      % put out error message
        success = 0;                                          % indicate an error to the calling function
        return;                                             % return
end;


%----------------------------------
% write image
%----------------------------------

imwrite( uint8( round( imageRGB * 256 ) ), outputfilename, 'tiff')
if( verb ) fprintf('Image successfully reconstructed...\nImage written to "%s"...\n', outputfilename); end;

%----------------------------------
% return to caller
%----------------------------------

success = 1;
return ; % return success