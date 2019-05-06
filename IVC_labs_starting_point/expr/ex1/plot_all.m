clear all;

img_name = 'sail.tif';
compression_method = 'rgbsampling';
img = double(imread(img_name));

[br, cr, psnr] = compression_test(img, compression_method);
fprintf(1, "Image name: %s \ncompression method: %s \nbit-rate: %d \ncompression rate: %.3f \npsnr: %.4f dB\n", ...
   img_name, compression_method, br, cr, psnr );