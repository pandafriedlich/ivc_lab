function block = IDCT8x8(coeff)
%  Function Name : IDCT8x8.m
%  Input         : coeff (DCT Coefficients) 8*8*3
%  Output        : block (original image block) 8*8*3
    [bh, bw, bd] = size(coeff);    
    block = zeros([bh, bw, bd]);

    for ch = 1:1:bd
        block(:, :, ch) = idct2(coeff(:, :, ch));
    end
    
end