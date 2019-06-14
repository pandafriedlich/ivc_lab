% general script, e.g. image loading, function calls, etc.
imageLena_small = double(imread('lena_small.tif'));
imageLena = double(imread('lena.tif'));
bits_small      = [1 2 3 5 7];
bits = [3 5];
PSNR_small = [];
for bit = bits_small
    qImageLena_small = UniQuant(imageLena_small, bit);
    recImage_small   = InvUniQuant(qImageLena_small, bit);
    PSNR_small = [PSNR_small calcPSNR(imageLena_small, recImage_small)];
end

PSNR = [];
for bit = bits
    qImageLena = UniQuant(imageLena, bit);
    recImage   = InvUniQuant(qImageLena, bit);
    PSNR = [PSNR calcPSNR(imageLena, recImage)];
end

...
    
% define your functions, e.g. calcPSNR, UniQuant, InvUniQuant
function qImage = UniQuant(image, bits)
%  Input         : image (Original Image)
%                : bits (bits available for representatives)
%
%  Output        : qImage (Quantized Image)
    % 
    src = double(image);
    
    ds = 256/(2^bits);
    qImage = floor(src / ds);
end

function image = InvUniQuant(qImage, bits)
%  Input         : qImage (Quantized Image)
%                : bits (bits available for representatives)
%
%  Output        : image (Mid-rise de-quantized Image)
    ds = 256/(2^bits);
    image = round((qImage + 0.5) *ds);
end

function PSNR = calcPSNR( image1, image2 )
    mse = calcMSE(image1, image2);
    PSNR = 10*log10((256-1)^2/mse);
end

function MSE = calcMSE( image1, image2 )
    [h, w, d] = size(image1);
    MSE = sum(sum(sum( (image1 - image2).^2)))/h/w/d;
end