function image = InvLloydMax(qImage, clusters)
%  Input         : qImage   (Quantized Image)
%                  clusters (Quantization Table)
%  Output        : image    (Recovered Image)
    Q = @(x) clusters(x);
    image = arrayfun(Q, qImage);
end