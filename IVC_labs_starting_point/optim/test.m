ENCSTRUCT.err_min = err_min;
ENCSTRUCT.BinCode_err = BinCode_err  ;
ENCSTRUCT.Codelengths_err = Codelengths_err ;
ENCSTRUCT.BinCode_mv = BinCode_mv;
ENCSTRUCT.Codelengths_mv = Codelengths_mv;

E2 = IY2 - PY2;
dst1 = InterEncode(E2, qScale, false);
codeLength(dst1(:)-err_min+1, Codelengths_err)

[height, width,~] = size(E2);

CL2 = 0;
for i = 1:height/16
    for j = 1:width/16
        blk = E2(16*i-15:16*i, 16*j-15:16*j, :);
        dst_blk = InterEncode(blk, qScale, false);
        CL2 = CL2 + codeLength(dst_blk(:)-err_min+1, Codelengths_err);
        
    end
end


CL2