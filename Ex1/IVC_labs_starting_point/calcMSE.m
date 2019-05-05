function mse = calcMSE(im1, im2, scaling )
    
    [h, w, d] = size(im1);
    
    if scaling
        im1 = im1 * 255;
        im2 = im2 * 255;
    end
    
    mse = sum( (im1 - im2).^2, 'all')/h/w/d;
    
    
        
    end