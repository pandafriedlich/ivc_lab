function ent = calc_entropy2d(pmf2d)
    [h, w] = size(pmf2d);
    ent = 0;
    
    for r = 1:h
        for c = 1:w
            if pmf2d(r, c) > 0
                ent = ent - pmf2d(r,c) * log2(pmf2d(r,c));
            end
        end
    end
end