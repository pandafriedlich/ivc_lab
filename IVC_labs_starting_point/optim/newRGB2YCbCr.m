function ycbcr_img = newRGB2YCbCr( rgb_img)

    V =[0.5815    0.5793    0.5712;
       -0.7531    0.1178    0.6472;
       -0.3077    0.8066   -0.5048];
    V(1,:) = V(1,:)/sum(V(1,:),'all');
    [h, w, d] = size(rgb_img);
    if d ~= 3
        error("image must have 3 channels");
    end
    ycbcr_img = zeros(h, w, d);
    
    for r = 1:h
        for c = 1:w
            ycbcr_img(r, c, 1) = V(1,:)*[rgb_img(r, c, 1);rgb_img(r, c, 2);rgb_img(r, c, 3)];
            ycbcr_img(r, c, 2) = V(2,:)*[rgb_img(r, c, 1);rgb_img(r, c, 2);rgb_img(r, c, 3)];
            ycbcr_img(r, c, 3) = V(3,:)*[rgb_img(r, c, 1);rgb_img(r, c, 2);rgb_img(r, c, 3)];
            
        end
    end 
    
    
    

end

