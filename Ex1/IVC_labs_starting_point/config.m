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
%           %%%    %%%          %%%%%%%%%   CONFIG.M
%
%
% config calculated offline parameters and stores them to config.mat
%
%
% input:        none
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%
%-----------------------------------------------------------------------------------


clear all   % clear memory
close all   % close all windows

path(path,'analysis')       % let matlab access the analysis directory
path(path,'encoder')        % ...
path(path,'decoder') 
path(path,'data') 
path(path,'data/images')
path(path, 'expr');
path(path, 'functions');



% uncomment the next line only to keep important results in config.mat without calculating them again
% be careful: you might overwrite important variables in you encoder and decoder by loading config.mat !!!

%load config.mat % load previous results to prevent from deleting tables that have been created before


%--------------------------
% compression types
%--------------------------

ID_nocompression         = 0;        % define the ID for a not compressed stream
ID_omit                  = 1;        % define the ID for storing nothing

%--------------------------
% quantization ID's
%--------------------------

ID_1bit                  = 1;        % ID's  n-bit quantization (ID_unif_quantization) or Lloyd-Max Algorithm (initialization)
ID_2bit                  = 2;        
ID_3bit                  = 3;        
ID_4bit                  = 4;         
ID_5bit                  = 5;         
ID_6bit                  = 6;        
ID_7bit                  = 7;        
ID_8bit                  = 8;        

%--------------------------
% outputcolor formats
%--------------------------

ID_grayscale             = 0;         % ID for converting to grayscale image before compression
ID_RGB                   = 1;         % ID for leaving the color format as is
ID_YCbCr_rev             = 2;         % ID for converting to YCbCr (reversible)
ID_YCbCr_irrev           = 3;         % ID for converting to YCbCr (irreversible)
ID_sRGB                  = 4;         % ID for converting to sRGB (gamma correction)

%--------------------------
% size formats
%--------------------------

ID_same                  = 0;         % ID for leaving the image size as is
ID_CIF                   = 1;         % ID for converting to CIF before compression
ID_QCIF                  = 2;         % ID for converting to QCIF before compression

%--------------------------
% verbose modes
%--------------------------

ID_verbose_off           = 0;        % ID for turning of verbose mode
ID_verbose_on            = 1;        % ID for turning on verbose mode

%--------------------------
% Parameter setup
%--------------------------

clear ParameterStruct

ParameterStruct(1).name='smandril.tif - starting algorithm';                % Name of the investigated compression mode
ParameterStruct(1).input_image_filename='data/images/smandril.tif';         % Input image file name
ParameterStruct(1).intermediate_resolution=ID_same;                         % Resolution to which the input will be converted 
ParameterStruct(1).intermediate_colorformat=ID_grayscale;                   % Color format to which the input will be converted
ParameterStruct(1).compression_type=ID_nocompression;                       % Compression mode
ParameterStruct(1).output_stream_filename='data/compressed/smandril.ivc';   % Output file name (Compressed)
ParameterStruct(1).verbose=ID_verbose_on;                                   % Status is shown during compression
ParameterStruct(1).reserved1=0;                                             % Reserved1
ParameterStruct(1).reserved2=0;                                             % Reserved2
ParameterStruct(1).reconstructed_image_filename='data/reconstructed/smandril.tif';    % Output file name (Reconstructed)


ParameterStruct(2).name='lena.tif - starting algorithm';                % Name of the investigated compression mode
ParameterStruct(2).input_image_filename='data/images/lena.tif';         % Input image file name
ParameterStruct(2).intermediate_resolution=ID_same;                         % Resolution to which the input will be converted 
ParameterStruct(2).intermediate_colorformat=ID_grayscale;                   % Color format to which the input will be converted
ParameterStruct(2).compression_type=ID_nocompression;                       % Compression mode
ParameterStruct(2).output_stream_filename='data/compressed/lena.ivc';   % Output file name (Compressed)
ParameterStruct(2).verbose=ID_verbose_on;                                   % Status is shown during compression
ParameterStruct(2).reserved1=0;                                             % Reserved1
ParameterStruct(2).reserved2=0;                                             % Reserved2
ParameterStruct(2).reconstructed_image_filename='data/reconstructed/lena.tif';    % Output file name (Reconstructed)


ParameterStruct(3).name='monarch.tif - starting algorithm';                % Name of the investigated compression mode
ParameterStruct(3).input_image_filename='data/images/monarch.tif';         % Input image file name
ParameterStruct(3).intermediate_resolution=ID_same;                         % Resolution to which the input will be converted 
ParameterStruct(3).intermediate_colorformat=ID_grayscale;                   % Color format to which the input will be converted
ParameterStruct(3).compression_type=ID_nocompression;                       % Compression mode
ParameterStruct(3).output_stream_filename='data/compressed/monarch.ivc';   % Output file name (Compressed)
ParameterStruct(3).verbose=ID_verbose_on;                                   % Status is shown during compression
ParameterStruct(3).reserved1=0;                                             % Reserved1
ParameterStruct(3).reserved2=0;                                             % Reserved2
ParameterStruct(3).reconstructed_image_filename='data/reconstructed/monarch.tif';    % Output file name (Reconstructed)


%--------------------------
% write configuration file
%--------------------------

save data/config.mat

fprintf('\n\n''config.m'' stored!\n');

