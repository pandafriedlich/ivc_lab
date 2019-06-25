clear ; clc; close all;

lena = double(imread('lena.tif'));
lena_small = double(imread('lena_small.tif'));

 

scales = 4: -0.2 : 0.4; % quantization scale factor, for E(4-1), we just evaluate scale factor of 1
bitPerPixel = zeros( numel(scales), 1);
PSNR = zeros( numel(scales), 1);

for scaleIdx = 1 : numel(scales)
    qScale   = scales(scaleIdx);
    k_small  = IntraEncode(lena_small, qScale);
    k        = IntraEncode(lena, qScale);   
    
    k_min = min(min(k_small), min(k));
    k_max = max(max(k_small), max(k));     
    
    % use pmf of k_small to build and train huffman table
    %your code here
    H = hist(k_small(:),k_min:k_max);
    H = H/sum(H);
    [ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );
    
    % use trained table to encode k to get the bytestream
    % your code here
    bytestream = enc_huffman( k(:) - k_min +1, BinCode, Codelengths);
    k_rec = double(reshape( dec_huffman ( bytestream, BinaryTree, max(size(k(:))) ), size(k))) +k_min -1;

    bitPerPixel(scaleIdx) = (numel(bytestream)*8) / (numel(lena)/3);
    
    % image reconstruction
    I_rec = IntraDecode(k_rec, size(lena),qScale);
    PSNR(scaleIdx) = calcPSNR(lena, I_rec, false);
    fprintf('QP: %.1f bit-rate: %.2f bits/pixel PSNR: %.2fdB\n', qScale, bitPerPixel(scaleIdx), PSNR(scaleIdx))
end
% imshow(I_rec/255);
plot(bitPerPixel, PSNR, 'bx-');
