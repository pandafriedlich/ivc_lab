%% preparation
clear; clc;

qScale = 1;
seq_finfo = dir("./data/sequence/foreman20_40_RGB/*.bmp");
bitrates = zeros(21, 1);
psnrs = zeros(21, 1);

%% first frame, the reference
I1 = double(imread(seq_finfo(1).name));
I2 = double(imread(seq_finfo(2).name));
IY1 = ictRGB2YCbCr(I1);
IY2 = ictRGB2YCbCr(I2);

%% transmit 1st frame, using lena_small to train the codebook
lena_small = double(imread('lena_small.tif'));
k_small  = IntraEncode(lena_small, qScale);
IY1_intra = IntraEncode(I1, qScale);
% k_min = min(min(k_small), min(IY1_intra));
% k_max = max(max(k_small), max(IY1_intra));   
% H = hist(k_small(:),k_min:k_max);
% H = H/sum(H);
% [ BinaryTree_fr, HuffCode_fr, BinCode_fr, Codelengths_fr] = ...
%     buildHuffman( H );
% bytestream_fr = enc_huffman( IY1_intra(:) - k_min +1, BinCode_fr, Codelengths_fr);
% IY1_intra_rec = double(reshape( dec_huffman ( bytestream_fr, BinaryTree_fr, max(size(IY1_intra(:))) ), size(IY1_intra)))...
%     +k_min -1;
% bitrates(1) = (numel(bytestream_fr)*8) / (numel(I1)/3);
I1_rec = IntraDecode(IY1_intra, size(I1),qScale);
psnrs(1) = calcPSNR(I1, I1_rec, false);

%% training MV huffman table
motion_1 = SSD(IY1(:, :, 1), IY2(:, :, 1));
pmf_mv = hist(motion_1(:), 1:1:81);
pmf_mv = pmf_mv / sum(pmf_mv);
[ BinaryTree_mv, HuffCode_mv, BinCode_mv, Codelengths_mv] =...
    buildHuffman( pmf_mv );


%% encode prediction error
PY2 = SSD_rec(IY1, motion_1);
E2 = IY2 - PY2;
dst = IntraEncode(E2, qScale);
err_min = -10;
EoB = 1999;
pmf_err = hist(dst(:), err_min: EoB);
pmf_err = pmf_err/sum(pmf_err);

[ BinaryTree_err, HuffCode_err, BinCode_err, Codelengths_err] =...
    buildHuffman( pmf_err );
% 




