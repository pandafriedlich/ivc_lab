function [ rgb_img ] = resample_ycbcr_decoder( YCbCr_down )
    [h, w, d] = size(YCbCr_down);
    if d ~= 3
        error("Dimension error!");
    end
    Y = YCbCr_down(:, :, 1);
    Cb_down = YCbCr_down(1:h/2, 1:w/2, 2);
    Cr_down = YCbCr_down(1:h/2, 1:w/2, 3);
    
    Cb_up = resample( resample(Cb_down, 2, 1, 3)', 2, 1, 3)';
    Cr_up = resample( resample(Cr_down, 2, 1, 3)', 2, 1, 3)';
    [h, w] =size(Y);
    reconstructed_image = zeros(h, w, 3);
    reconstructed_image(:, :, 1) = round(Y);
    reconstructed_image(:, :, 2) = round(Cb_up);
    reconstructed_image(:, :, 3) = round(Cr_up);

    rgb_img = ictYCbCr2RGB(reconstructed_image);


end

