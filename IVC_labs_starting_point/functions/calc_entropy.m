function H = calc_entropy( pmf )
    % calculate the entropy given a probability measurement function pmf
    if sum(pmf < 0 | pmf > 1)
        error("Invalid PMF!")
    end
    
    H = 0;
    for i=1:length(pmf)
        
        if pmf(i) > 0
            H = H - pmf(i)* log2(pmf(i));
        end
            
    end

end

