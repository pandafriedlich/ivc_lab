function joint_pmf = stats_joint(in_image, overlap)
    joint_pmf = zeros(256, 256);
    
    [h, w, d] = size(in_image);
    n_samples = 0;
    if overlap
        cstep = 1;
    else
        cstep = 2;
    end
    
    % (x, y) = (right pixel, left pixel)
    % vertical direction: left pixel(y)
    % horizontal direction: right pixel(x)
    % |-------------------> x(right pixel)
    % |
    % |
    % |
    % |
    % |
    % y(left pixel)
    
    
    for ch = 1:1:d
       % for every channel
       for r = 1:1:h
           for c = 1:cstep:w-1
               x = in_image(r,c+1,ch); y = in_image(r, c,ch);
               joint_pmf(y+1, x+1) = ...
                   joint_pmf(y+1, x+1) + 1;
               n_samples = n_samples + 1;               
           end
       end
    end
    joint_pmf = joint_pmf/n_samples;
    
    
    
end