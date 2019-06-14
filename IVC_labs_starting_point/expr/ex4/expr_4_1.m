clear ; clc; close all;


lena_small = double(imread('lena_small.tif'));
lena = double(imread('lena.tif'));

scales = 1 : 0.6 : 1; % quantization scale factor, for E(4-1), we just evaluate scale factor of 1
bitPerPixel = zeros( numel(scales));

for scaleIdx = 1 : numel(scales)
    qScale   = scales(scaleIdx);
    k_small  = IntraEncode(lena_small, qScale);
    k        = IntraEncode(lena, qScale);
    % use pmf of k_small to build and train huffman table
    %your code here
    H = hist(k_small(:),-100:999);
    H = H/sum(H);
    [ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );
    
    % use trained table to encode k to get the bytestream
    % your code here
    bytestream = enc_huffman( k(:) + 100, BinCode, Codelengths);
    bitPerPixel(scaleIdx) = (numel(bytestream)*8) / (numel(lena)/3);
    
    % image reconstruction
%     I_rec = IntraDecode(k_rec, size(lena),qScale);
%     PSNR(scaleIdx) = calcPSNR(Lena, I_rec, false);
%     fprintf('QP: %.1f bit-rate: %.2f bits/pixel PSNR: %.2fdB\n', qScale, bitPerPixel(scaleIdx), PSNR(scaleIdx))
end
