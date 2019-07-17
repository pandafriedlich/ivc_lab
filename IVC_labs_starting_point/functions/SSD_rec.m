function rec_image = SSD_rec(ref_image, motion_vectors)
    %  Input         : ref_image(Reference Image, YCbCr image)
    %                  motion_vectors
    %
    %  Output        : rec_image (Reconstructed current image, YCbCr image)

    rec_image = zeros(size(ref_image));
    [height, width, ~] = size(ref_image);
    
    blk_sz = 8;
    sw = 4;
    sw_width = 2*sw + 1;
    n_blk_h = height/blk_sz;
    n_blk_w = width/blk_sz;
    
    for i = 1:n_blk_h
        for j = 1:n_blk_w
            pt_h = blk_sz*(i-1)+1;
            pt_w = blk_sz*(j-1)+1;
            
            [h_off, w_off] = ind2sub([sw_width,sw_width], motion_vectors(i,j)) ;
            % motion compensation
            pt_h1 = pt_h + h_off - sw-1;   
            pt_w1 = pt_w + w_off - sw-1;   % coordiante of correspondence in reference frame
            
            rec_image(pt_h:pt_h+blk_sz-1, pt_w:pt_w+blk_sz-1, :) = ...
                ref_image(pt_h1:pt_h1+blk_sz-1, pt_w1:pt_w1+blk_sz-1, :);
                
        end
    end
end