function [qImage, clusters] = LloydMax(image, bits, epsilon)
%  Input         : image (Original RGB Image)
%                  bits (bits for quantization)
%                  epsilon (Stop Condition)
%  Output        : qImage (Quantized Image)
%                  clusters (Quantization Table)
    image = double(image);
    [h, w, d] = size(image);
%     lambda = 0;
    
    reps = ((0:1:(2^bits-1)) + 0.5) * (256/(2^bits));
    sigma_x = zeros(size(reps));
    len_bq = zeros(size(reps));
    J = 1;
    
    im_vec = image(:);
    while true
        J_prev = J;
        [D, I] = pdist2(reps', im_vec, 'euclidean', 'Smallest', 1);
        
        for q=1:1:(2^bits)
            Bq = im_vec(I == q);
            sigma_x(q) = sum(Bq, 'all');
            len_bq(q) = length(Bq);
        end
        J = sum(D.^2, 'all')/length(D);
        if (abs(J - J_prev)/J_prev) < epsilon
            break;
        else
            % update reps
            reps = sigma_x ./ len_bq;
        end
        
    end
    qImage = reshape(I,[h, w, d]);
    clusters = reps';


end