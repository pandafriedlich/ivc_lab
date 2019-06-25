function zze = ZeroRunEnc_EoB(zz, EOB)
%  Input         : zz (Zig-zag scanned block, 1x64)
%                  EOB (End Of Block symbol, scalar)
%
%  Output        : zze (zero-run-level encoded block, 1xM)
    
    
    prev_is_zero = 0;       % state machine, using prev_is_zero
    zero_counting = 0;
    zze = [];
    zz_len = length(zz);
    
    for i = 1:1:zz_len
        q = zz(i);
        if q ~= 0
            if prev_is_zero == 1
                zze = [zze, 0, zero_counting];
            end
            zze = [zze, q];
            prev_is_zero = 0;
        else
            if prev_is_zero == 1
                zero_counting = zero_counting + 1;
            else
                prev_is_zero = 1;
                zero_counting = 0;
            end
            if i == zz_len
                zze = [zze, EOB];
            end
        end
    end
%     zze = [zze, EOB];
    
end