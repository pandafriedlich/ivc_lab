function block = IDCT8x8(coeff)
%  Function Name : IDCT8x8.m
%  Input         : coeff (DCT Coefficients) 8*8*3
%  Output        : block (original image block) 8*8*3
    block = zeros(size(coeff));
    
    for ch = 1:1:3
        block(:, :, ch) = idct2(coeff(:, :, ch));
    end
    
end