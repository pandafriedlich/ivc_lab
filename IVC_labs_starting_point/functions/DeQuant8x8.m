function dct_block = DeQuant8x8(quant_block, qScale)
%  Function Name : DeQuant8x8.m
%  Input         : quant_block  (Quantized Block, 8x8x3)
%                  qScale       (Quantization Parameter, scalar)
%
%  Output        : dct_block    (Dequantized DCT coefficients, 8x8x3)

    L = qScale*[16, 11, 10, 16, 24, 40, 51, 61;
        12, 12, 14, 19, 26, 58, 60, 55;
        14, 13, 16, 24, 40, 57, 69, 56;
        14, 17, 22, 29, 51, 87, 80, 62;
        18, 55, 37, 56, 68, 109, 103, 77;
        24, 35, 55, 64, 81, 104, 113, 92;
        49, 64, 78, 87, 103, 121, 120, 101;
        72, 92, 95, 98, 112, 100, 103, 99];
    
    C =  qScale*[17, 18, 24, 47, 99, 99, 99, 99;
        18, 21, 26, 66, 99, 99, 99, 99;
        24, 13, 56, 99, 99, 99, 99, 99;
        47, 66, 99, 99, 99, 99, 99, 99;
        99, 99, 99, 99, 99, 99, 99, 99;
        99, 99, 99, 99, 99, 99, 99, 99;
        99, 99, 99, 99, 99, 99, 99, 99;
        99, 99, 99, 99, 99, 99, 99, 99; ];
    
     dct_block = zeros(size(quant_block));
     dct_block(:, :, 1) = (quant_block(:, :, 1) .* L);
     dct_block(:, :, 2) = (quant_block(:, :, 2) .* C);
     dct_block(:, :, 3) = (quant_block(:, :, 3) .* C);
end