function qImage = UniQuant(image, bits)
%  Input         : image (Original Image)
%                : bits (bits available for representatives)
%
%  Output        : qImage (Quantized Image)
    % 
    src = double(image);
    
    ds = 256/(2^bits);
    qImage = floor(src / ds);
    
    
    

end