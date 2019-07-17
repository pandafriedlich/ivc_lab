function [bm, mv]  = search_best_match(Iref, blk, r, c, sw)
    [height, width, ~] = size(Iref);
    [~, blk_sz, ~] = size(blk);
    cnt = 0;
    min_ssd = Inf;
    for w2 = c-sw:c+sw
        for  h2 =  r-sw:r+sw
            cnt = cnt + 1;
            if (h2 <= 0) || (h2 > (height-blk_sz+1))|| (w2 > (width-blk_sz+1))|| (w2 <= 0)
                continue;
            end

            err = Iref(h2:h2+blk_sz-1, w2:w2+blk_sz-1, 1)...
                - blk(:,:, 1);
            ssd = sum(sum(err.^2));
            if ssd < min_ssd
                bm = Iref(h2:h2+blk_sz-1, w2:w2+blk_sz-1, :);
                min_ssd = ssd;
                mv = cnt;
            end

        end
    end



end