function [ cond_ent ] = calc_condent( joint_pmf, cond_pmf )
    
    [h, w] = size(joint_pmf);
    cond_ent = 0;
    
    for r = 1:1:h
        for c = 1:1:w
            if cond_pmf(r,c) > 0
                cond_ent = cond_ent - log2(cond_pmf(r,c))*joint_pmf(r,c);
            end
        end
    end


end

