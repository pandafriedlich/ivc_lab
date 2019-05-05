clear all;

sail = double(imread('sail.tif'));
sail_down = resample_encoder(sail);
sail_up = resample_decoder(sail_down);
figure;
subplot(121)
imshow(sail/255);

subplot(122)
imshow(sail_up/255);
calcPSNR(sail, sail_up, 0);


lena = double(imread('lena.tif'));
lena_down = resample_encoder(lena);
lena_up = resample_decoder(lena_down);
calcPSNR(lena, lena_up, 0);
figure;
subplot(121)
imshow(lena/255);

subplot(122)
imshow(lena_up/255);
