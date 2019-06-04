function [clusters, Temp_clusters] = VectorQuantizer(image, bits, epsilon, bsize)
%  Function Name : VectorQuantizer.m
%  Input         : image    (Original Image)
%                  bit      (bits for each block)
%                  epsilon  (Stop Condition)
%                  bsize    (Block Size)
%  Output        : clusters (Quantization Representatives), size(clusters) = [2^bit, bsize^2];
%                  Temp_clusters (Intermediate Quantization Representatives for each iteration)
    % initialization
    reps = ((0:1:(2^bits-1)) + 0.5 ) * (256/(2^bits));
    clusters = repmat(reps', [1, bsize^2]);
    len_bq = zeros(2^bits, 1);
    J = 1;
    
    % transform image into vector table
    [h, w, d] = size(image);
    image_blk_vector = zeros(h*w*d/bsize, bsize);
    image_concat = [image(:, :, 1), image(:, :, 2), image(:,:, 3)];
    for b = 1:bsize
        image_blk_vector(:, b) = reshape(image_concat(:, b:bsize:end), [], 1);
    end
    n_samples = size(image_blk_vector, 1)/bsize;
    training_table = zeros(n_samples, bsize^2);
    for t = 1:1:n_samples
        blk = image_blk_vector( bsize*(t-1)+1:bsize*t, 1:bsize)';
        training_table(t, :) = blk(:);
    end
    
    
    % optimize
    n_iter = 0;
    
    while true
        % training
        [I, D]   = knnsearch(clusters, training_table,...
            'Distance', 'euclidean');
        for q=1:1:(2^bits)
            Bq = training_table(I == q, :);
            len_bq(q) = size(Bq, 1);
            if len_bq(q) > 0
                % update non-zero cells
                clusters(q, :) = sum(Bq, 1) ./ len_bq(q);
            end
        end
        
        % cell spliting
        Temp_clusters = clusters;
        zerocells = find(len_bq == 0);
        for zc = zerocells'
            % find out the cell with maximum length
            [max_len, max_idx] = max(len_bq);
            % spliting
            offset = zeros(1, bsize^2);
            offset(end) = 1;
            Temp_clusters(zc, :) = Temp_clusters(max_idx, :) + offset;
            len_bq(max_idx) = ceil(max_len/2);
            len_bq(zc) = floor(max_len/2);
        end
        
        n_iter = n_iter + 1;
        clusters = Temp_clusters;
        %evaluate distortion
        
%         [I, D]   = knnsearch(clusters, training_table,...
%             'Distance', 'euclidean');
        
        J_prev = J;   
        J = sum(D .^2, 'all')/length(D);
%         fprintf(1, "Iteration: %d \t J: %.4f, Splitting: %d\n", n_iter, J, length(zerocells));
        if (abs(J - J_prev)/J_prev) < epsilon
            break;
        end
    end
    
end