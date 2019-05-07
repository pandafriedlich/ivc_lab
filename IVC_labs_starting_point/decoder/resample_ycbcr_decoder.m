function [ rgb_img ] = resample_ycbcr_decoder( YCbCr_down )
    [h, w, d] = size(YCbCr_down);
    
    if d ~= 3
        error("Dimension error!");
    end
    
    fc = 3;
    nt = 4;
    
    Y = YCbCr_down(:, :, 1);
    Cb_down = padarray(YCbCr_down(1:h/2, 1:w/2, 2), [nt/2, nt/2], 'symmetric');
    Cr_down = padarray(YCbCr_down(1:h/2, 1:w/2, 3), [nt/2, nt/2], 'symmetric');
    
    Cb_up = resample( resample(Cb_down, 2, 1, fc)', 2, 1, fc)';
    Cr_up = resample( resample(Cr_down, 2, 1, fc)', 2, 1, fc)';
    [h, w] =size(Y);
    
    reconstructed_image = zeros(h, w, 3);
    
    reconstructed_image(:, :, 1) = (Y);
    reconstructed_image(:, :, 2) = (Cb_up(nt+1:end-nt, nt+1:end-nt));
    reconstructed_image(:, :, 3) = (Cr_up(nt+1:end-nt, nt+1:end-nt));

    rgb_img = ictYCbCr2RGB(reconstructed_image);


end

