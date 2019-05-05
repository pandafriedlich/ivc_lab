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
% input:        bytestream        - Encoded bitstream
%               BinaryTree        - Binary Tree of the Code created by buildHuffma
%               nr_symbols        - Number of symbols to decode
%
% returnvalue:  output            - decoded data
%
% Course:       Image and Video Compression
%               Prof. Eckehard Steinbach
%
% Author:       Dipl.-Ing. Ingo Bauermann 
%               02.01.2003 (created)
%
%-----------------------------------------------------------------------------------

function [output] = dec_huffman (bytestream, BinaryTree, nr_symbols);

output = zeros(1,nr_symbols);

fid = fopen('bits.bin','w');
fwrite( fid, bytestream, 'uint8');
fclose( fid );

fid = fopen('bits.bin','r');
ctemp = BinaryTree;

i = 1;
while(i <= nr_symbols)
    while(isa(ctemp,'cell'))
        next = fread(fid,1,'ubit1')+1;
        ctemp = ctemp{next};
    end;
    output(i) = ctemp;
    ctemp = BinaryTree;
    i=i+1;
end;

fclose(fid);

return
