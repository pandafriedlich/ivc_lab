% example program to show the usage of huffman encoding and decoding
% functions

clc
clear all
close all

path(path,'encoder')            % make the encoder-functions visible to matlab
path(path,'decoder')            % make the encoder-functions visible to matlab
path(path,'analysis')           % make the encoder-functions visible to matlab

A = double(imread('data/images/lena_small.tif'));

H = hist(A(:),0:255);
H = H/sum(H);

[ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );

bytestream = enc_huffman( A(:) + 1, BinCode, Codelengths);

Reconstructed_Data = double(reshape( dec_huffman ( bytestream, BinaryTree, max(size(A(:))) ), size(A))) - 1;

figure
imagesc(A/256)

figure
imagesc(Reconstructed_Data/256)
