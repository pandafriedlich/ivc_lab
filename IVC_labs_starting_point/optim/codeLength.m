function CL = codeLength(data, Codelengths)
    CL = 0;
    for i = 1:1:length(data)
        CL = CL + Codelengths(data(i));
    end


end