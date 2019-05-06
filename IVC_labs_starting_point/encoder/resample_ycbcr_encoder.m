function YCbCr_down= resample_ycbcr_encoder( img, transform )
     if transform
         img = ictRGB2YCbCr(img);
     end
     
    Y = img(:, :, 1);
    Cb = img(:, :, 2);
    Cr = img(:, :, 3);
    
    Cb_down = resample( resample(Cb, 1, 2, 3)', 1, 2, 3)';
    Cr_down = resample( resample(Cr, 1, 2, 3)', 1, 2, 3)';
    
    YCbCr_down = zeros(size(img));
    [h, w] = size(Cb_down);
    YCbCr_down(:, :, 1) =Y;
    YCbCr_down(1:h, 1:w, 2) = Cb_down;
    YCbCr_down(1:h, 1:w, 3) = Cr_down;
    

end

