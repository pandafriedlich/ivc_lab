function YCbCr_down= resample_ycbcr_encoder( img, transform )
     if transform == 1
         img = ictRGB2YCbCr(img);
     end
    
    fc = 3;
    nt = 4;   
    
    
    Y = img(:, :, 1);
    Cb = padarray(img(:, :, 2), [nt, nt], 'symmetric');
    Cr = padarray(img(:, :, 3), [nt, nt], 'symmetric');
    
    
    Cb_down = resample( resample(Cb, 1, 2, fc)', 1, 2, fc)';
    Cr_down = resample( resample(Cr, 1, 2, fc)', 1, 2, fc)';
    
    YCbCr_down = zeros(size(img));
    [h, w] = size(Cb_down);
    h = h - nt;
    w = w - nt;
    
    YCbCr_down(:, :, 1) =Y;
    YCbCr_down(1:h, 1:w, 2) = Cb_down(nt/2+1:end-nt/2, nt/2+1: end-nt/2);
    YCbCr_down(1:h, 1:w, 3) = Cr_down(nt/2+1:end-nt/2, nt/2+1: end-nt/2);
    

end

