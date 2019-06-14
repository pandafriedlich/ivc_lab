function dst = IntraDecode(image, img_size , qScale)
%  Function Name : IntraDecode.m
%  Input         : image (zero-run encoded image, 1xN)
%                  img_size (original image size)
%                  qScale(quantization scale)
%  Output        : dst   (decoded image)
    im_vs = img_size(1);
    im_hs = img_size(2);
    im_ch = img_size(3);
    
    dst = zeros(im_vs, im_hs, im_ch);
    
    EoB = 999;
    n_frames_ch = (im_vs/8) * (im_hs/8);
    n_frames_v = (im_vs/8);
    n_frames_h = (im_hs/8);
    
    current_frame = [];
    frame_cnt = 0;
    for symb = image
        current_frame = [current_frame, symb];
        if symb ~= EoB
            continue;
        else
            frame_cnt = frame_cnt + 1;
            blk_zz = ZeroRunDec_EoB(current_frame, EoB);
            blk = DeZigZag8x8(blk_zz');
            
            % computing the position of this block
            ch = ceil(frame_cnt/n_frames_ch);
            frame_cnt_ch = mod(frame_cnt, n_frames_ch);
            if frame_cnt_ch == 0
                frame_cnt_ch = n_frames_ch;
            end
            [frame_nv, frame_nh] = ind2sub([n_frames_v, n_frames_h], frame_cnt_ch);
            dst(8*frame_nv-7: 8*frame_nv, 8*frame_nh-7: 8*frame_nh, ch) = 0;
            
        end
        
        
    end
    
    
    
end