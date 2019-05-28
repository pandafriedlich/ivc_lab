function image = InvUniQuant(qImage, bits)
%  Input         : qImage (Quantized Image)
%                : bits (bits available for representatives)
%
%  Output        : image (Mid-rise de-quantized Image)
    ds = 256/(2^bits);
    image = round((qImage + 0.5) *ds);


end