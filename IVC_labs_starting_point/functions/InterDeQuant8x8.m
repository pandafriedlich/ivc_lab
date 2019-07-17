function dct_block = InterDeQuant8x8(quant_block, qScale)
%  Function Name : DeQuant8x8.m
%  Input         : quant_block  (Quantized Block, 8x8x3)
%                  qScale       (Quantization Parameter, scalar)
%
%  Output        : dct_block    (Dequantized DCT coefficients, 8x8x3)

    L = qScale*32*ones(8,8);  
    C =  L;
    
     dct_block = zeros(size(quant_block));
     dct_block(:, :, 1) = (quant_block(:, :, 1) .* L);
     dct_block(:, :, 2) = (quant_block(:, :, 2) .* C);
     dct_block(:, :, 3) = (quant_block(:, :, 3) .* C);
end