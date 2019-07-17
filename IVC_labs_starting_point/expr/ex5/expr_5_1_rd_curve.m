
n_q = 0;
bitrates_rd_video = [];
psnrs_rd_video = [];
for qScale = 2:-0.2:0.2
    n_q = n_q + 1;
    expr_5_1_video;
    bitrates_rd_video(n_q) = mean(bitrates);
    psnrs_rd_video(n_q) = mean(psnrs);
end
figure;
plot(bitrates_rd_video, psnrs_rd_video,'rx-','MarkerSize',10);hold on;
%%
% clear;
% qScale = 1;
% 
% seq_finfo = dir("./data/sequence/foreman20_40_RGB/*.bmp");
% bitrates_rd_still = [];
% psnrs_rd_still = [];
% lena_small = double(imread('lena_small.tif'));
% k_small  = IntraEncode(lena_small, qScale);
% k_min = -100; k_max = 1999;
% H = hist(k_small(:),k_min:k_max);
% H = H/sum(H);
% [ BinaryTree_fr, HuffCode_fr, BinCode_fr, Codelengths_fr] = ...
%     buildHuffman( H );
% for j=1:21
%     
%     Ij = double(imread(seq_finfo(j).name));
%     IYj_intra = IntraEncode(Ij, qScale);
%     bytestream_fr = enc_huffman( IYj_intra(:) - k_min +1, BinCode_fr, Codelengths_fr);
%     IYj_intra_rec = double(reshape( dec_huffman ( bytestream_fr, BinaryTree_fr, max(size(IYj_intra(:))) ), size(IYj_intra)))...
%         +k_min -1;
%     bitrates_rd_still(1) = (numel(bytestream_fr)*8) / (numel(Ij)/3);
%     Ij_rec = IntraDecode(IYj_intra_rec, size(Ij),qScale);
%     psnrs_rd_still(1) = calcPSNR(Ij, (Ij_rec), false);
%     fprintf("\tFrame %-4d, bitrate: %.4f [bps], PSNR: %.4f [dB]\n",...
%         1, bitrates_rd_still(1), psnrs_rd_still(1));
% end