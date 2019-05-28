function H = calc_entropy( pmf, varargin )
    % calculate the entropy given a probability measurement function pmf
    if sum(pmf < 0 | pmf > 1)
        error("Invalid PMF!");
    end
    
    H = 0;
    n_vararg = length(varargin);
   
    if n_vararg == 0
        % if no table PMF provided
        for i=1:length(pmf)    
            if pmf(i) > 0
                H = H - pmf(i)* log2(pmf(i));
            end
        end
        
    else 
        % encoding with a given table
        table_pmf = cell2mat(varargin(1));
        if sum(table_pmf < 0 | table_pmf > 1)
            error("Invalid table PMF!")
        end
        
        for i=1:length(pmf)    
            if table_pmf(i) > 0
                H = H - pmf(i)* log2(table_pmf(i));
            end
        end
        
    end

end

