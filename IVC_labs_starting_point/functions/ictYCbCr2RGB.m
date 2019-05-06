function [ rgb_img ] = ictYCbCr2RGB( ycbcr_img )
    
    [h, w, d] = size(ycbcr_img);
    if d ~= 3
        error("image must have 3 channels");
    end
    rgb_img = zeros(h, w, d);
    
    for r = 1:h
        for c = 1:w
            rgb_img(r, c, 1) = [1, 0, 1.402]*[ycbcr_img(r, c, 1);ycbcr_img(r, c, 2);ycbcr_img(r, c, 3)];
            rgb_img(r, c, 2) = [1, -0.344, -0.714]*[ycbcr_img(r, c, 1);ycbcr_img(r, c, 2);ycbcr_img(r, c, 3)];
            rgb_img(r, c, 3) = [1, 1.772, 0]*[ycbcr_img(r, c, 1);ycbcr_img(r, c, 2);ycbcr_img(r, c, 3)];
            
        end
    end
    
    
    

end



