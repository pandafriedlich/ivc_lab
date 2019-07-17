function [V, offset] = getColorSpaceTransform(img)
    [h, w, ~] = size(img);
    img = double(img);
    n_blk_h = h/16;
    n_blk_w = w/16;
    ftrain = zeros(3, h*w);
    n_blk = 0;
    for j = 1:1:n_blk_h
        for i = 1:1:n_blk_w
            n_blk = n_blk + 1;
            blk = img(16*(j-1)+1:16*j, 16*(i-1)+1:16*i, :);
            blk_train = [reshape(blk(:,:,1), 1, 16*16);
                reshape(blk(:,:,2), 1, 16*16);
                reshape(blk(:,:,3), 1, 16*16)];
            blk_train = blk_train - mean(blk_train, 2);
            ftrain(:, ((n_blk-1)*16*16+1):(16*16*n_blk)) = blk_train;
        end
    end
    ftrain_cov = ftrain*ftrain';
    [V, ~] = eig(ftrain_cov);
    V = fliplr(V)';
    t1 = V(1, :)/sum(V(1, :), 'all')*219/255;
    scale = 224/255/sum(abs(V(2,:)),'all');
    t2  = V(2,:)*scale;
    t3 = V(3,:)*scale;
    
    T = [t1;t2;t3];
    
    offcb = -sum(t2(t2 < 0), 'all')*255+16;
    offcr = -sum(t3(t3 < 0), 'all')*255+16;
    offset = [16;offcb;offcr];
    
    
    


end

