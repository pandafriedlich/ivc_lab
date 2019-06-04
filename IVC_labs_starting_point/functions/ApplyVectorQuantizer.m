function qImage = ApplyVectorQuantizer(image, clusters, bsize)
%  Function Name : ApplyVectorQuantizer.m
%  Input         : image    (Original Image)
%                  clusters (Quantization Representatives)
%                  bsize    (Block Size)
%  Output        : qImage   (Quantized Image)

    % transform image into vector table
    [h, w, d] = size(image);
    image_blk_vector = zeros(h*w*d/bsize, bsize);
    image_concat = [image(:, :, 1), image(:, :, 2), image(:,:, 3)];
    for b = 1:bsize
        image_blk_vector(:, b) = reshape(image_concat(:, b:bsize:end), [], 1);
    end
    n_samples = size(image_blk_vector, 1)/bsize;
    vectorized_image_blocks = zeros(n_samples, bsize^2);
    for t = 1:1:n_samples
        blk = image_blk_vector( bsize*(t-1)+1:bsize*t, 1:bsize)';
        vectorized_image_blocks(t, :) = blk(:);
    end
    
    [qImage, ~] = knnsearch(clusters, vectorized_image_blocks, 'Distance', 'euclidean');
    qImage = reshape(qImage, [h/bsize, w/bsize, d]);
    
end