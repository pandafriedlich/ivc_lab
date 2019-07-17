function [ rgb_img ] = newYCbCr2RGB( ycbcr_img)
        
    V =[0.5815    0.5793    0.5712;
       -0.7531    0.1178    0.6472;
       -0.3077    0.8066   -0.5048];
   
    V(1,:) = V(1,:)/sum(V(1,:),'all');
    Vinv = V^-1;
    [h, w, d] = size(ycbcr_img);
    if d ~= 3
        error("image must have 3 channels");
    end
    rgb_img = zeros(h, w, d);
    off = 0;
    for r = 1:h
        for c = 1:w
            rgb_img(r, c, 1) = Vinv(1,:)*([ycbcr_img(r, c, 1);ycbcr_img(r, c, 2);ycbcr_img(r, c, 3)]-off);
            rgb_img(r, c, 2) = Vinv(2,:)*([ycbcr_img(r, c, 1);ycbcr_img(r, c, 2);ycbcr_img(r, c, 3)] - off);
            rgb_img(r, c, 3) = Vinv(3,:)*([ycbcr_img(r, c, 1);ycbcr_img(r, c, 2);ycbcr_img(r, c, 3)] - off);
            
        end
    end
    
    
    

end



