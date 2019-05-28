function pmf = stats_marg( image1, force_range, varargin )
    % estimate PMF of an uint8 image, images is a cell containing a set of 
    % images
       
    % processing first image    
    samps = image1(:);
    
    % processing following images, if there is any
    n_varargin = length(varargin);    
    for i = 1:n_varargin
        vari = cell2mat(varargin(i));        
        samps = [samps; vari(:)];
    end
    
    if force_range
        lb = 0; hb = 255;
    else
        lb = min(samps); hb = max(samps);
    end
    
    pmf = hist(samps, lb:hb);
    pmf = pmf/sum(pmf);
    

end

