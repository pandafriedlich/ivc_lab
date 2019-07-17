function quant = InterQuant8x8(dct_block, qScale)
%  Input         : dct_block (Original Coefficients, 8x8x3)
%                  qScale (Quantization Parameter, scalar)
%
%  Output        : quant (Quantized Coefficients, 8x8x3)
    L = qScale*32*ones(8,8);
    C =  L;
    
     quant = zeros(size(dct_block));
     quant(:, :, 1) = round(dct_block(:, :, 1) ./ L);
     quant(:, :, 2) = round(dct_block(:, :, 2) ./ C);
     quant(:, :, 3) = round(dct_block(:, :, 3) ./ C);
     
     
    
end