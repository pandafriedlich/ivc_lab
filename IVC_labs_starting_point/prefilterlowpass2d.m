function img_filtered = prefilterlowpass2d(im1, W)
%     W = [1, 2, 1;
%         2, 4, 2;
%         1, 2, 1];
    W = W/sum(sum(W));
    [fs, ~] = size(W);
    offset = (fs -1)/2;
    
    [~, ~, d] = size(im1);
    img_filtered = im1;
    for i = 1:d
        
        imch = conv2(im1(:, :, i), W);
        img_filtered(:, :, i) = imch(1+offset:end-offset, 1+offset:end-offset);
       
    end
    
end

