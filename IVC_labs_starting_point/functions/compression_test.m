function [br, cr, psnr] = compression_test( image, method )
    if method == 'rgbsampling'
        downs = resample_encoder(image);
        
        % compression
        [h, w, ~] = size(image);
        [hc, wc, dc] =size(downs);
        br = hc*wc*dc*8/h/w;
        cr = h*w/hc/dc;
        
        % reconstruction
        ups = resample_decoder(downs);
        psnr = calcPSNR(image, ups, 0);
        
        
    elseif method == 'chromsampling'
        disp("Not supported yet");
        
    elseif method == 'starting'
        disp("Not supported yet");
        
    else
        error("supported methods are: 'rgbsampling', 'rgbsampling', 'starting'");
        
        


end

