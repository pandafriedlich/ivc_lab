clear all; clc; close all;

imfile = 'lena.tif';
lena = double(imread(imfile));
M = 3;
[qImage, clusters] = LloydMax(lena, M, 0.001);
lena_reconst = InvLloydMax(qImage, clusters);
PSNR = calcPSNR(lena, lena_reconst, false);
fprintf(1, 'File: [%s], PSNR: %.4f [dB]\n', imfile, PSNR);
imshow(lena_reconst/255);