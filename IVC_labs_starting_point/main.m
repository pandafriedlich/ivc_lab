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
%           %%%    %%%          %%%%%%%%%   MAIN.M
%
%
% main program for IVC scheme prototype
%
%
% input:       none
%
% Course:      Image and Video Compression
%              Prof. Eckehard Steinbach
%
% Author:      Dipl.-Ing. Ingo Bauermann 
%              02.01.2003 (created)
%              15.03.2004 (easier structure implemented)
%
%
%---------------------------------------------------------------

clear all                   % clear workspace
close all                   % close all figures
clc                         % clear command window

path( path, 'analysis' )    % make the analysis-functions visible to matlab
load data/config.mat        % load Parameters and filenames from config.mat

%----------------------------------------------------------------
%
%   Main Loop for Parameter Sets
%
%----------------------------------------------------------------

[ dummy SetSize ] = size( ParameterStruct );  % get number of different parameter sets available (defined in config.m)
for akSet = 1:SetSize                         % and loop through all of them
        
    %---------------------------------------------------------
    % invoke image compressor with current parameter set index
    %---------------------------------------------------------
    if( encode( akSet ) == 0 )      
        fprintf('\n\n-----------------------------------\n ENCODING FAILED - ABORTING\n\n'); % warn the user if encoding fails for some reason
        return;                                         % and leave the program
    else
        if( ParameterStruct( akSet ).verbose == ID_verbose_on ) fprintf('\n- ENCODING COMPLETE\n-----------------------------------\n\n'); end;        % everything seems to be OK
    end;
        
    %-----------------------------------------------------------
    % invoke image decompressor with current parameter set index
    %-----------------------------------------------------------
    if( decode( akSet ) == 0 )
        fprintf('\n\n-----------------------------------\n DECODING FAILED - ABORTING\n\n');
        return
    else
        if( ParameterStruct( akSet ).verbose == ID_verbose_on ) fprintf('\n- DECODING COMPLETE\n-----------------------------------\n\n');   end; 
    end;
    
    
    %----------------------------
    % analyse results
    %----------------------------
    if( ParameterStruct( akSet ).verbose == ID_verbose_on ) fprintf( '\n-----------------------------------\n- ANALYSING\n' ); end;
    
    ORIGINAL_image = double( imread( ParameterStruct( akSet ).input_image_filename ) ) / 256;                 % load original image and convert it to double with value range from 0 to 1
    RECONSTRUCTED_image = double( imread( ParameterStruct( akSet ).reconstructed_image_filename ) ) / 256;    % load reconstructed image...
    [ ORIGINAL_height ORIGINAL_width ORIGINAL_dimensions ] = size( ORIGINAL_image );                          % size of the original image
    [ RECONSTRUCTED_height RECONSTRUCTED_width RECONSTRUCTED_dimensions ] = size( RECONSTRUCTED_image );      % size of reconstructed image
        
    RECONSTRUCTED_image = resizeImage( RECONSTRUCTED_image, ORIGINAL_height, ORIGINAL_width);  % bring the reconstructed image back to the original size

    figure( 'Name', ParameterStruct( akSet ).name )                 % open window  
    
    subplot(1,2,1);                                                 % prepare to show two images in one window (left)
    imagesc( ORIGINAL_image, [0 1] );                               % show original image
    axis image;                                                     % set aspect ratio
    title('Original Image')                                         % draw title
    
    subplot(1,2,2);                                                 % prepare to show two images in one window (right)
    imagesc( RECONSTRUCTED_image, [0 1] );                          % show reconstructed image
    axis image;                                                     % set aspect ratio
    title('Reconstructed Image')                                    % draw title
    
    fid = fopen( ParameterStruct( akSet ).output_stream_filename );      % open bitstream
    if(fid<0)                                                            % if open fails -> bail out
        fprintf( 'Could`n open file "%s" !', output_stream_filename );
        return;
    end
    stream = fread( fid, inf, 'uchar' );                             % read bitstream
    fclose( fid );                                                   % close bitstream
    
    ORIGINAL_size = size( ORIGINAL_image( : ) );                     % get size of original image (Bytes)
    COMPRESSED_size = size( stream( : ) );                           % get size of stream (Bytes)

    if( ParameterStruct( akSet ).verbose == ID_verbose_on ) 
        fprintf('\nParameter set: "%s" (no. %d)\n', ParameterStruct( akSet ).name, akSet );
        fprintf('\nOriginal file:     ~%d kB (%d Bytes)\nBit stream:        ~%d kB (%d Bytes)', round( ORIGINAL_size( 1, 1) / 1000 ), ORIGINAL_size( 1, 1 ), round( COMPRESSED_size( 1, 1) / 1000 ), COMPRESSED_size( 1, 1 ) );
        fprintf('\nCompressionratio:  ~%.2f \n\n',ORIGINAL_size( 1, 1 )/COMPRESSED_size( 1, 1));
		fprintf( '- ANALYSING\n-----------------------------------\n\n' );
    end;
    psnr = calcPSNR(ORIGINAL_image, RECONSTRUCTED_image, 1)
end;

%----------------------------------------------------------------
%
%   Rate-Distortion Analysis
%
%----------------------------------------------------------------


% place distortion calculation etc. here


%----------------------------------------------------------------
%
%   Main Loop for Parameter Sets ends
%
%----------------------------------------------------------------

