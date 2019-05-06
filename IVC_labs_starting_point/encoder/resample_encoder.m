%% resample encoder
function downs = resample_encoder(img)
    [h, w, d] = size(img);
    nt = 4;
    fp = 3;
    
    downs = zeros(h/2, w/2, d);
    
    for ch = 1:d
        % wrapping 
        img_wrapped = padarray(img(:, :, ch), [nt, nt], 'symmetric');
        % resample
        img_ds = resample( resample(img_wrapped, 1,  2, fp)', 1, 2, fp)';
               
        % crop back
        downs(:, :, ch) = img_ds(3:end-2, 3:end-2);
        
    end
    
end