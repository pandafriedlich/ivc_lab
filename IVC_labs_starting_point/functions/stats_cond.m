function [joint_pmf, cond_pmf] = stats_cond(input_image)
    
    joint_pmf = stats_joint(input_image, true);
    pmf_y = sum(joint_pmf, 2);          % marginal pmf of y
    cond_pmf = joint_pmf ./ repmat(pmf_y, [1, 256]);    
    
end