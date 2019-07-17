function [modeMat, MV, PY2, EY2, n_bits1, n_bits2] = mode_decision(IY1R, IY2, lambda, qScale, ENCSTRUCT)

sw = 4; % searching window size
blk_sz = 16;
[height, width, ~] = size(IY2);
modeMat = zeros(height/blk_sz, width/blk_sz);
 
err_min = ENCSTRUCT.err_min;
BinCode_err = ENCSTRUCT.BinCode_err;
Codelengths_err = ENCSTRUCT.Codelengths_err;
BinCode_mv = ENCSTRUCT.BinCode_mv;
Codelengths_mv =  ENCSTRUCT.Codelengths_mv;
MV = [];
PY2 = zeros(size(IY2));
EY2 = zeros(size(IY2));

n_bits1 = 0;
n_bits2 = 0;

for i = 1:1:height/blk_sz
    for j = 1:1:width/blk_sz
        MBij = IY2(16*i-15:16*i, 16*j-15:16*j,:);
       %% mode 1
        h = blk_sz*(i-1)+1;
        w = blk_sz*(j-1)+1;
        % search in the neighboorhood in reference frame
        [Pij, MVij] = search_best_match(IY1R, MBij, h, w, sw);            
        Eij = MBij - Pij;
        Eij_RLC = InterEncode(Eij, qScale, false);
        %bytestream_Eij = enc_huffman( Eij_RLC(:)-err_min+1, BinCode_err, Codelengths_err);
        %BS_MVij = enc_huffman(MVij(:), BinCode_mv, Codelengths_mv);
        BS_Eij = codeLength( Eij_RLC(:)-err_min+1, Codelengths_err);
        BS_MVij = codeLength(MVij(:), Codelengths_mv);
        J1 = lambda*(BS_Eij + BS_MVij) + sum(Eij.^2,'all');


        %% mode 4
        % 8x8 block x4 
        % SUBB1
        J2 = 0;
        SUBB1 = MBij(1:8, 1:8, :);
        [P1, MV1] = search_best_match(IY1R, SUBB1, h, w, sw);
        E1 = SUBB1 - P1;
        E1_RLC = InterEncode(E1, qScale, false);
        BS_E1 = codeLength( E1_RLC(:)-err_min+1,Codelengths_err);
        BS_MV1 = codeLength(MV1(:), Codelengths_mv);
        J2 = J2 + lambda*(BS_E1+BS_MV1) + sum(E1.^2,'all');

        SUBB2 = MBij(1:8, 9:16, :);
        [P2, MV2] = search_best_match(IY1R, SUBB2, h, w+8, sw);
        E2 = SUBB2 - P2;
        E2_RLC = InterEncode(E2, qScale, false);
        BS_E2 = codeLength( E2_RLC(:)-err_min+1,Codelengths_err);
        BS_MV2 = codeLength(MV2(:), Codelengths_mv);
        J2 = J2 + lambda*(BS_E2+BS_MV2) + sum(E2.^2,'all');

        SUBB3 = MBij(9:16, 1:8, :);
        [P3, MV3] = search_best_match(IY1R, SUBB3, h+8, w, sw);
        E3 = SUBB3 - P3;
        E3_RLC = InterEncode(E3, qScale, false);
        BS_E3 = codeLength( E3_RLC(:)-err_min+1,Codelengths_err);
        BS_MV3 = codeLength(MV3(:), Codelengths_mv);
        J2 = J2 + lambda*(BS_E3+BS_MV3) + sum(E3.^2,'all');

        SUBB4 = MBij(9:16, 9:16, :);
        [P4, MV4] = search_best_match(IY1R, SUBB4, h+8, w+8, sw);
        E4 = SUBB4 - P4;
        E4_RLC = InterEncode(E4, qScale, false);
        BS_E4 = codeLength( E4_RLC(:)-err_min+1,Codelengths_err);
        BS_MV4 = codeLength(MV4(:), Codelengths_mv);
        J2 = J2 + lambda*(BS_E4+BS_MV4) + sum(E4.^2,'all');
        if J1 < J2
%             fprintf("(%d, %d): J1: %.4f, J2:%.4f\n",  i, j, J1, J2);
            modeMat(i, j) = 0;
            MV = [MV, MVij];
            PY2(16*i-15:16*i, 16*j-15:16*j, :) = Pij;
            EY2(16*i-15:16*i, 16*j-15:16*j, :) = Eij;
            n_bits1 = n_bits1 + BS_Eij; 
            n_bits2 = n_bits2 + BS_MVij; 
        else
            
            modeMat(i, j) = 1;
            MV = [MV, [MV1, MV2, MV3, MV4]];
            PY2(16*i-15:16*i, 16*j-15:16*j, :) = [P1, P2; P3, P4];
            EY2(16*i-15:16*i, 16*j-15:16*j, :) = [E1, E2; E3, E4];
            n_bits1 = n_bits1 + BS_E1+BS_E2+BS_E3+BS_E4;
            n_bits2 = n_bits2 +BS_MV1+BS_MV2+BS_MV3+BS_MV4;
        end
    end
end

end
