function ups = resample_decoder(img)

    [h, w, d] = size(img);
    nt = 2;
    fp = 3;
    ups = zeros(h*2, w*2, d);
    
    for ch = 1:d
        % wrap
        img_wrapped = padarray(img(:, :, ch), [nt, nt], 'symmetric');
        % resample
        row_rs = resample(img_wrapped, 2, 1, fp);
        img_ups = resample( row_rs', 2, 1, fp)';
        % crop
        ups(:, :, ch) = img_ups(5:end-4, 5:end-4);
        
    end

end