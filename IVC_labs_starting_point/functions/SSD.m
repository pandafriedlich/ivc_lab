function motion_vectors_indices = SSD(ref_image, image)
%  Input         : ref_image(Reference Image, size: height x width)
%                  image (Current Image, size: height x width)
%
%  Output        : motion_vectors_indices (Motion Vector Indices, size: (height/8) x (width/8) x 1 )
    
    if size(ref_image) ~= size(image)
       error('frame size disparity between im and ref_im'); 
    end
    
    [height, width, ~] = size(image);
    sw = 4; % searching window size
    blk_sz = 8;
    n_blk_h = height/blk_sz;
    n_blk_w = width/blk_sz;
    motion_vectors_indices = zeros(n_blk_h, width/n_blk_w);
    
    % estimate motion between current frame and reference frame
    % using Y channel
    for i = 1:n_blk_h
        for j = 1:n_blk_w
            % for each block
            % upperleft pixel of the block
            h = blk_sz*(i-1)+1; 
            w = blk_sz*(j-1)+1;
            
            min_ssd = Inf;
            min_index = 0;
            cnt = 0;
            
            % search in the neighboorhood in reference frame
            for w2 = w-sw:w+sw
                for  h2 =  h-sw:h+sw
                    cnt = cnt + 1;
                    if (h2 <= 0) || (h2 > (height-blk_sz+1))|| (w2 > (width-blk_sz+1))|| (w2 <= 0)
                        continue;
                    end
                    
                    err = ref_image(h2:h2+blk_sz-1, w2:w2+blk_sz-1)...
                        - image(h:h+blk_sz-1, w:w+blk_sz-1);
                    ssd = sum(sum(err.^2));
                    if ssd < min_ssd
                        min_ssd = ssd;
                        min_index = cnt;
                    end
                       
                end
            end
            motion_vectors_indices(i,j) = min_index;
            
        end
    end
    

end