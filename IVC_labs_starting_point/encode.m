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
%           %%%    %%%          %%%%%%%%%   ENCODE.M
%
%
% organises the encoding process of the image
%
% input:        number of actual ParameterSet to use
%
% returnvalue:  success          - 0: some error occured
%                                - 1: bitstream written
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%               15.03.2004 (easier structure implemented)
%
%-----------------------------------------------------------------------------------

function [ success ] = encode( akSet )

load data/config.mat            % load offline parameters

input_image_filename       = ParameterStruct( akSet ).input_image_filename;        % get filename for actual image (frame) to be compressed
intermediate_resolution    = ParameterStruct( akSet ).intermediate_resolution;     % get resolution of the compressed representation
intermediate_colorformat   = ParameterStruct( akSet ).intermediate_colorformat;    % get colorformat of the compressed representation
compression_type           = ParameterStruct( akSet ).compression_type;            % compression scheme to use
output_stream_filename     = ParameterStruct( akSet ).output_stream_filename;      % filename of the compressed representation
verb                       = ParameterStruct( akSet ).verbose;                     % show debugging information or not
reserved1                  = ParameterStruct( akSet ).reserved1;                   % reserved 
reserved2                  = ParameterStruct( akSet ).reserved2;                   % reserved

path(path,'encoder')            % make the encoder-functions visible to matlab
path(path,'decoder')            % make the encoder-functions visible to matlab
path(path,'analysis')           % make the encoder-functions visible to matlab

%---------------------------------
% read image
%---------------------------------

if( verb ) fprintf('\n\n-----------------------------------\n- ENCODING\n\nReading image...\n'); end;          % show message if verbose mode is on 
ORIGINAL_image = double( imread( input_image_filename ) ) / 256;                   % read the image (scale 0..1)
[ height width dimensions ] = size( ORIGINAL_image );                             % get image dimensions (visible throughout this function)

if( dimensions == 1 )                                                       % grayscale -> convert to RGB
    if( verb ) fprintf('Converting to RGB...\n');end;
    RGB_image( :, :, 2 ) = ORIGINAL_image( :, :, 1 );
    RGB_image( :, :, 3 ) = ORIGINAL_image( :, :, 1 );
else
    RGB_image = ORIGINAL_image;
end
 
%---------------------------------
% convert to intermediate resolution
%---------------------------------

switch ( intermediate_resolution )      % resize the image
    case ( ID_same )                    % resolution stays the same
        % nothing to do here
        
    %-----------------------------------------    
    % ADD new intermediate resolutions here
    %-----------------------------------------
        
    otherwise                                                  % error 
        disp('image resolution not valid - exiting');          % put out error message
        success = 0;                                           % indicate an error to the calling function
        return;                                                % return
end;



%---------------------------------
% convert to output colorformat
%---------------------------------

switch ( intermediate_colorformat )                           % perform conversion on input image
    case ( ID_grayscale )                                     % image is converted to grayscale 
        if( verb ) disp('Converting to grayscale...'); end; 
        CT_image = RGB2GRAYscale( RGB_image );                % convert to RGB-grayscale (still in 3-Component format)
        
    case ( ID_RGB )                                           % image is converted to RGB mode for further processing
        CT_image = RGB_image;                                 % just copy RGB to RGB
 
        
    %------------------------    
    % ADD new formats here
    %------------------------       
        

    otherwise                                                       % error 
        disp('Input-colorformat not valid - exiting');              % put out error message
        success = 0;                                                % indicate an error to the calling function
        return;                                                     % return
end;
   
%-----------------------------------
% compress image (build bytestream)
%-----------------------------------

if( intermediate_colorformat == ID_grayscale )                             % check if this is a grayscale image
    switch lower( compression_type )                                 % test for compression type
        case ( ID_nocompression )                                   % if no compression should be applied -> nothing has to be done 
            if( verb ) disp('Converting image to bytestream (uncompressed)...');end;  
            bytestream = uint8( floor( CT_image( : ) * 256.0 ) );  % except for converting the whole image to a binary format
            
        case ( ID_omit )
            bytestream = [];                                        % nothing to store            
            
        otherwise                                                   % if an error occurs -> bail out
            disp('Not implemented:');                 
            disp( compressiontype );
            success = 0;
            return;
    end;
else
    switch ( compression_type )                                      % test for compression type
        case ( ID_nocompression )                                   % no compression has to be performed
            if( verb ) disp('Converting image to bytestream (uncompressed)...');end;  
            bytestream = uint8( round( CT_image( : ) * 256.0 ) );  % except for converting the whole image to a binary format

        case ( ID_omit )
            bytestream = [];                                        % nothing to store             
            
   
        %--------------------------------
        % Add compression schemes here
        %--------------------------------                           
        
                              
      otherwise                                                     % if an compression type is not implemented yet
            disp('Not implemented:');
            disp( compressiontype );
            success = 0;
            return;
    end;    
end;
        
%----------------------------------
% write bitstream
%----------------------------------

[ height width dim ] = size ( CT_image );                          % get dimensions of compressed image
if(~writeBitstream( output_stream_filename, height, width, compression_type, intermediate_colorformat, reserved1, reserved2, bytestream, verb ) ) % write the header and data
    disp('Could not write output!');
    success = 0;
    return;
end;

%----------------------------------
% return to caller
%----------------------------------

success = 1;
return ; % return success