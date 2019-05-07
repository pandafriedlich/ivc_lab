function pmf = stats_marg( image )
    % estimate PMF of an uint8 image
    [h, w, d] = size(image);
    if (d == 1) || (d == 3)
        pmf = zeros(256, d);
        for channel = 1:d
            for intensity = 0:255
                pmf(intensity+1 , channel) = sum(sum(image(:, :, channel) == intensity))/h/w;                
            end
        end
    else 
        error("image must be either 1-D or 3-D");
    end
    


end

