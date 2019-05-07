

img = double(imread('sail.tif'));

YCbCr_down = resample_ycbcr_encoder(img, 1);
reconstructed_image = resample_ycbcr_decoder(YCbCr_down);


figure();
subplot(1,2,1);
imshow(img/255);
subplot(1,2,2);
imshow(reconstructed_image/255);

psnr = calcPSNR(round(img), round(reconstructed_image), 0)




