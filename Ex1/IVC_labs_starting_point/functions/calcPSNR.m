function psnr = calcPSNR(im1, im2, scaling)
    mse = calcMSE(im1, im2, scaling);
    psnr = 10*log10((256-1)^2/mse);
    
end