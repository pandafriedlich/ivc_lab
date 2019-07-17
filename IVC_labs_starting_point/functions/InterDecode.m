function dst = InterDecode(image, img_size , qScale, trans)
%  Function Name : IntraDecode.m
%  Input         : image (zero-run encoded image, 1xN)
%                  img_size (original image size)
%                  qScale(quantization scale)
%  Output        : dst   (decoded image)
    im_vs = img_size(1);
    im_hs = img_size(2);
    im_ch = img_size(3);
    
    dst = ones(im_vs, im_hs, im_ch);
    
    EoB = 2999;
    n_frames_ch = (im_vs/8) * (im_hs/8);
    n_frames_v = (im_vs/8);
    n_frames_h = (im_hs/8);
    
    current_frame = [];
    frame_cnt = 0;
    
    % recover quantized DCT
    dst_q = zeros(im_vs, im_hs, im_ch);
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
            [frame_nh, frame_nv] = ind2sub([n_frames_h, n_frames_v], frame_cnt_ch);
            dst_q(8*frame_nv-7: 8*frame_nv, 8*frame_nh-7: 8*frame_nh, ch) = blk;
            current_frame = [];
        end
    end
    
     for vi = 1:1:n_frames_v
       for hi = 1:1:n_frames_h
           blk_q = dst_q(8*vi-7:8*vi, 8*hi-7:8*hi, :);
           % de-quantization
           blk_dq = DeQuant8x8(blk_q, qScale);
           % inverse DCT
           dst(8*vi-7:8*vi, 8*hi-7:8*hi, :) = IDCT8x8(blk_dq);
       end
     end
     
     if (nargin == 3) || ((nargin == 4) && (trans == true))
        dst = round(ictYCbCr2RGB(dst));
     end
    
end

