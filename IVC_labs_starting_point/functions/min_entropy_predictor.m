function [D, D_size] = min_entropy_predictor(img, chrom_subsample)
    % 
    raw_image = ictRGB2YCbCr(img);
    [h, w, d] = size(raw_image);
    
    if chrom_subsample
        S = resample_ycbcr_encoder(raw_image, 0);
        h_range = h/2; 
        w_range = w/2;
        D_size = [h, h_range, h_range;
            w, w_range, w_range];
        
    else
        S = raw_image;
        h_range = h; 
        w_range = w;
        D_size = [h, h_range, h_range;
            w, w_range, w_range];
    end
    
    
    D = round(S);
    Sprime = D;
    

    coef = [7/8, -1/2, 5/8; %Y
        3/8, -1/4, 7/8; %Cb
        3/8, -1/4, 7/8; %Cb
        ];
    ch = 1;
    for r = 2:h
        for c = 2:w
            % elements used for prediction
            s123 = [Sprime(r, c-1, ch); Sprime(r-1, c-1, ch); Sprime(r-1, c, ch)];
            % prediction
            P = coef(ch, :) * s123;
            % error
            D(r, c, ch) = round(S(r, c, ch) - P);
            % recover Sprime
            Sprime(r, c, ch) = P + D(r, c, ch);
        end
    end
    
    for ch = 2:1:d
        for r = 2:h_range
            for c = 2:w_range
                % elements used for prediction
                s123 = [Sprime(r, c-1, ch); Sprime(r-1, c-1, ch); Sprime(r-1, c, ch)];
                % prediction
                P = coef(ch, :) * s123;
                % error
                D(r, c, ch) = round(S(r, c, ch) - P);
                % recover Sprime
                Sprime(r, c, ch) = P + D(r, c, ch);
            end
        end
    end
    
end

