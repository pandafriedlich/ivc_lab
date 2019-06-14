function dst = ZeroRunDec_EoB(src, EoB)
%  Function Name : ZeroRunDec1.m zero run level decoder
%  Input         : src (zero run encoded sequence 1xM with EoB sign in the end)
%                  EoB (end of block sign)
%
%  Output        : dst (reconstructed single zig-zag scanned block 1x64)
    src_len = length(src);
    dst = zeros(1, 64);
    dec_len = 0;
    
    zero_found = 0;
    
    for i = 1:1:src_len
       q = src(i);
       if q == EoB
           break;
       elseif q == 0
           if zero_found 
               % only 1 zero symbol
               dst(dec_len+1) = 0;
               dec_len = dec_len + 1;
               zero_found = 0;
           else
               zero_found = 1;
           end
       else
           if zero_found
               % this symbol represents number of zeros
               dst(dec_len+1:dec_len+1+q) = 0;
               dec_len = dec_len + q + 1;
           else
               dst(dec_len+1) = q;
               dec_len = dec_len + 1;
               
           end
           
           zero_found = 0;
       end
    end
    
end