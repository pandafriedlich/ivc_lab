%% preparation
seq_finfo = dir("./data/sequence/foreman20_40_RGB/*.bmp");
bitrates = zeros(21, 1);
psnrs = zeros(21, 1);
if ~exist('qScale','var')
    qScale = 1;
end

%% first 2 frames
I1 = double(imread(seq_finfo(1).name));
I2 = double(imread(seq_finfo(2).name));
IY1 = ictRGB2YCbCr(I1);
IY2 = ictRGB2YCbCr(I2);

%% transmit 1st frame, using lena_small to train the codebook
lena_small = double(imread('lena_small.tif'));
k_small  = IntraEncode(lena_small, qScale);
IY1_intra = IntraEncode(I1, qScale);
k_min = min(min(k_small), min(IY1_intra));
k_max = max(max(k_small), max(IY1_intra));   
H = hist(k_small(:),k_min:k_max);
H = H/sum(H);
[ BinaryTree_fr, HuffCode_fr, BinCode_fr, Codelengths_fr] = ...
    buildHuffman( H );
bytestream_fr = enc_huffman( IY1_intra(:) - k_min +1, BinCode_fr, Codelengths_fr);
IY1_intra_rec = double(reshape( dec_huffman ( bytestream_fr, BinaryTree_fr, max(size(IY1_intra(:))) ), size(IY1_intra)))...
    +k_min -1;
bitrates(1) = (numel(bytestream_fr)*8) / (numel(I1)/3);
I1_rec = IntraDecode(IY1_intra_rec, size(I1),qScale);
psnrs(1) = calcPSNR(I1, (I1_rec), false);
fprintf("\tFrame %-4d, bitrate: %.4f [bps], PSNR: %.4f [dB]\n", 1, bitrates(1), psnrs(1));
%% training MV huffman table
motion_1 = SSD(IY1(:, :, 1), IY2(:, :, 1));
pmf_mv = hist(motion_1(:), 1:1:9*9);
pmf_mv = pmf_mv / sum(pmf_mv);
[ BinaryTree_mv, HuffCode_mv, BinCode_mv, Codelengths_mv] =...
    buildHuffman( pmf_mv );


%% train prediction error huffman table
PY2 = SSD_rec(IY1, motion_1);
E2 = IY2 - PY2;
dst = InterEncode(E2, qScale, false);
E2_rec = InterDecode(dst, size(E2), qScale, false);
err_min = -400;
EoB = 2999;
pmf_err = hist(dst(:), err_min: EoB);
pmf_err = pmf_err/sum(pmf_err);

[ BinaryTree_err, HuffCode_err, BinCode_err, Codelengths_err] =...
    buildHuffman( pmf_err );

ENCSTRUCT.err_min = err_min;
ENCSTRUCT.BinCode_err = BinCode_err  ;
ENCSTRUCT.Codelengths_err = Codelengths_err ;
ENCSTRUCT.BinCode_mv = BinCode_mv;
ENCSTRUCT.Codelengths_mv = Codelengths_mv;


%% evaluating
decoded_frames = {I1_rec};
bytestream_mv = {bytestream_fr};
bytestream_err = {0};

for j = 2:1:21
    I_ref = decoded_frames{j-1};
    IY_ref = ictRGB2YCbCr(I_ref);
    
    Ij =  double(imread(seq_finfo(j).name));
    IYj = ictRGB2YCbCr(Ij);
    lambda = 2^((qScale-0.2)*0.5/0.2+1);
    
    [modeMat, MVj, PYj, Ej, n_bits1, n_bits2] = mode_decision(IY_ref, IYj, lambda, qScale, ENCSTRUCT);
    Ej_intra = InterEncode(Ej, qScale, false);
%     
%     bytestream_mv{j} = enc_huffman( MVj(:), BinCode_mv, Codelengths_mv);
%     bytestream_err{j} = enc_huffman( Ej_intra(:)-err_min+1, BinCode_err, Codelengths_err);
%     bitrates(j) = (numel(bytestream_mv{j})*8 + numel(bytestream_err{j})*8) / (numel(I1)/3);
    bitrates(j) = (n_bits1+n_bits2)/(numel(I1)/3);
    Ej_dec  = InterDecode(Ej_intra, size(Ej), qScale, false);
    IYj_dec = Ej_dec + PYj;
    Ij_dec = round(ictYCbCr2RGB(IYj_dec));
    psnrs(j) = calcPSNR(Ij, Ij_dec, false);
    decoded_frames{j} =  Ij_dec;
    fprintf("\tFrame %-4d, bitrate: %.4f [bps], PSNR: %.4f [dB]\n", j, bitrates(j), psnrs(j));
end
fprintf(2,"== Transmission End(qScale = %.4f) ==\n** bitrate: %8.4f[bps] PSNR: %8.4f [dB] **\n", ...
    qScale, mean(bitrates), mean(psnrs));
