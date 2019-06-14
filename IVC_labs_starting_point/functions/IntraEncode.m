function dst = IntraEncode(image, qScale)
%  Function Name : IntraEncode.m
%  Input         : image (Original RGB Image)
%                  qScale(quantization scale)
%  Output        : dst   (sequences after zero-run encoding, 1xN)
   
   image_yc = ictRGB2YCbCr(image);
   [vs, hs, ~] = size(image_yc);
   
   n_blks_v = vs/8;
   n_blks_h = hs/8;
   
   EoB = 999;
   
   Y_enc = [];
   Cb_enc = [];
   Cr_enc = [];
   
   for vi = 1:1:n_blks_v
       for hi = 1:1:n_blks_h
           blk = image_yc(8*vi-7:8*vi, 8*hi-7:8*hi, :);
           % DCT
           dct_blk = DCT8x8(blk);
           % Quantization
           dct_blk_q = Quant8x8(dct_blk, qScale);
           % zig-zag
           dct_blk_zz = ZigZag8x8(dct_blk_q);
           % zero-run encoding
           blk_Y_enc = ZeroRunEnc_EoB(dct_blk_zz(:, 1), EoB);
           blk_Cb_enc = ZeroRunEnc_EoB(dct_blk_zz(:, 2), EoB);
           blk_Cr_enc =ZeroRunEnc_EoB(dct_blk_zz(:, 3), EoB);
           
           Y_enc = [Y_enc, blk_Y_enc];
           Cb_enc = [Cb_enc, blk_Cb_enc];
           Cr_enc = [Cr_enc, blk_Cr_enc];
       end
   end
   
   dst = [Y_enc, Cb_enc, Cr_enc];
end
