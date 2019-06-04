function image = InvVectorQuantizer(qImage, clusters, block_size)
%  Function Name : VectorQuantizer.m
%  Input         : qImage     (Quantized Image)
%                  clusters   (Quantization clusters)
%                  block_size (Block Size)
%  Output        : image      (Dequantized Images)
    [qh, qw, qd] = size(qImage);
    qImage_vec = qImage(:);
    img_blk_vec = clusters(qImage_vec, :);
    img_blks_vec_expd = repelem(img_blk_vec, block_size, 1);
    
    for b = 1:block_size
        lb = (b-1)*block_size + 1;
        rb = (b)*block_size;
        img_blks_vec_expd(b:block_size:end, 1:block_size) =...
            img_blks_vec_expd(1:block_size:end, lb:rb);
        
    end
    
    img_blks_vec_expd = img_blks_vec_expd(:, 1:block_size);
    
    ih = qh * block_size;
    iw = qw * block_size;
    id = qd ;
    
    n_column_blk = block_size*length(qImage_vec)/ih;
    image = zeros(ih, iw, id);
    for cbi = 1:1:n_column_blk
        cb = img_blks_vec_expd( (1+ih*(cbi-1)) :(ih*cbi) , :);
        ch = ceil(cbi/(iw/block_size));
        idx_in_ch = cbi - (iw/block_size)*(ch-1);
        image(:, (1+block_size*(idx_in_ch -1)) : (block_size*idx_in_ch), ch ) = cb;
        
        
    end
    

end