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
%           %%%    %%%          %%%%%%%%%   BUILDHUFFMAN.M
%
%
% description:  creatre a huffman table from a given distribution
%
% input:        data              - Data to be encoded (indices to codewords!!!!
%               BinCode           - Binary version of the Code created by buildHuffman
%               Codelengths       - Array of Codelengthes created by buildHuffman
%
% returnvalue:  bytestream        - the encoded bytestream
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%
%-----------------------------------------------------------------------------------

function [bytestream] = enc_huffman( data, BinCode, Codelengths)

fid = fopen('bits.bin','w');
for i = 1:length(data)
    for j = 1:Codelengths(data(i));
        fwrite(fid,BinCode(data(i),j)-48,'ubit1');
    end
end;
fclose(fid);

fid = fopen('bits.bin','r');
bytestream = fread(fid,inf,'uint8');
fclose(fid);




            