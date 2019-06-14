%% Main
bits         = 8;
epsilon      = 0.1;
block_size   = 2;
%% lena small for VQ training
image_small  = double(imread('lena_small.tif'));
[clusters, Temp_clusters] = VectorQuantizer(image_small, bits, epsilon, block_size);
qImage_small              = ApplyVectorQuantizer(image_small, clusters, block_size);
%% Huffman table training
H = hist(qImage_small(:),1:(2^bits));
H = H/sum(H);

[ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );


%% 
image  = double(imread('lena.tif'));
qImage = ApplyVectorQuantizer(image, clusters, block_size);
%% Huffman encoding
bytestream = enc_huffman( qImage(:), BinCode, Codelengths);

%%
bpp  = (numel(bytestream) * 8) / (numel(image)/3);
%% Huffman decoding



%%
reconst_image  = InvVectorQuantizer(qImage, clusters, block_size);
PSNR = calcPSNR(image, reconst_image, false);
fprintf(1, 'bit rate: %.4f [bps], PSNR: %.4f [dB] \n', bpp, PSNR);