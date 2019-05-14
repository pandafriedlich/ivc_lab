function pmf = stats_marg( image1, varargin )
    % estimate PMF of an uint8 image, images is a cell containing a set of 
    % images
    pmf = zeros(256, 1);
    n_samples = 0;
       
    % processing first image
    [h, w, d] = size(image1);
    
    if (d == 1) || (d == 3)
        for channel = 1:d
            for intensity = 0:255
                pmf(intensity+1) = pmf(intensity+1) +  sum(sum(image1(:, :, channel) == intensity));                
            end
        end
    else
        error("image must be either 1-D or 3-D");
    end
    n_samples = n_samples + h*w*d;
    
    % processing following images, if there is any
    n_varargin = length(varargin);    
    for i = 1:n_varargin
        image = cell2mat(varargin(i));        
        [h, w, d] = size(image);
        if (d == 1) || (d == 3)
            for channel = 1:d
                for intensity = 0:255
                    pmf(intensity+1) = pmf(intensity+1) +  sum(sum(image(:, :, channel) == intensity));                
                end
            end
            

        else 
            error("image must be either 1-D or 3-D");
        end        
        n_samples = n_samples + h*w*d;
    end
    
    pmf = pmf/n_samples;

end

