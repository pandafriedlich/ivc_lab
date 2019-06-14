function coeff = DCT8x8(block)
%  Input         : block    (Original Image block, 8x8x3)
%
%  Output        : coeff    (DCT coefficients after transformation, 8x8x3)
    [bh, bw, bd] = size(block);
    coeff = zeros([bh, bw, bd]);
    
    for ch = 1:1:bd
        coeff(:, :, ch) = dct2(block(:, :, ch));
    end
    
end