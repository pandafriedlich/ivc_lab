

img = double(imread('sail.tif'));

% %color tranform
% img_ycbcr = ictRGB2YCbCr(img);
% 
% 
% % downsampling
% Y = img_ycbcr(:, :, 1);
% Cb = img_ycbcr(:, :, 2);
% Cr = img_ycbcr(:, :, 3);
% Cb_down = resample( resample(Cb, 1, 2, 3)', 1, 2, 3)';
% Cr_down = resample( resample(Cr, 1, 2, 3)', 1, 2, 3)';
YCbCr_down = resample_ycbcr_encoder(img, 1);

% reconstruction
% Cb_up = resample( resample(Cb_down, 2, 1, 3)', 2, 1, 3)';
% Cr_up = resample( resample(Cr_down, 2, 1, 3)', 2, 1, 3)';
% 
% reconstructed_image =img_ycbcr;
% reconstructed_image(:, :, 1) = round(Y);
% reconstructed_image(:, :, 2) = round(Cb_up);
% reconstructed_image(:, :, 3) = round(Cr_up);

reconstructed_image = resample_ycbcr_decoder(YCbCr_down);
figure();
subplot(1,2,1);
imshow(img/255);
subplot(1,2,2);
imshow(reconstructed_image/255);

psnr = calcPSNR(img, reconstructed_image, 0)




