function ycbcr_img = ictRGB2YCbCr( rgb_img )
    
    [h, w, d] = size(rgb_img);
    if d ~= 3
        error("image must have 3 channels");
    end
    ycbcr_img = zeros(h, w, d);
    
    for r = 1:h
        for c = 1:w
            ycbcr_img(r, c, 1) = [0.299, 0.587, 0.114]*[rgb_img(r, c, 1);rgb_img(r, c, 2);rgb_img(r, c, 3)];
            ycbcr_img(r, c, 2) = [-0.169,-0.331, 0.5]*[rgb_img(r, c, 1);rgb_img(r, c, 2);rgb_img(r, c, 3)];
            ycbcr_img(r, c, 3) = [0.5,- 0.419, - 0.081]*[rgb_img(r, c, 1);rgb_img(r, c, 2);rgb_img(r, c, 3)];
            
        end
    end
    
    
    

end

