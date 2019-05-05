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
%
%-----------------------------------------------------------------------------------

function [output] = dec_huffman_new (bytestream, BinaryTree, nr_symbols)

output = zeros(1,nr_symbols);
ctemp = BinaryTree;

dec = zeros(size(bytestream,1),8);
for i = 8:-1:1
    dec(:,i) = rem(bytestream,2);
    bytestream = floor(bytestream/2);
end

dec = dec(:,end:-1:1)';
a = dec(:);

i = 1;
p = 1;
while(i <= nr_symbols)&&p<=max(size(a))
    while(isa(ctemp,'cell'))
        next = a(p)+1;
        p = p+1;
        ctemp = ctemp{next};
    end;
    output(i) = ctemp;
    ctemp = BinaryTree;
    i=i+1;
end;






% ctemp = BinaryTree;
% i = 1;
% p = 1;
% while(i <= nr_symbols)
%     while(isa(ctemp,'cell'))
%         next = a(p)+1;
%         next
% p = p+1;
%         ctemp = ctemp{next};
%     end;
%     output2(i) = ctemp;
%     ctemp = BinaryTree;
%     i=i+1;
% end



%return
