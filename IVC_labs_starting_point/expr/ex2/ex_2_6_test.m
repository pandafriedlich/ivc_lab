% example program to show the usage of huffman encoding and decoding
% functions

clc
clear all
close all

path(path,'encoder')            % make the encoder-functions visible to matlab
path(path,'decoder')            % make the encoder-functions visible to matlab
path(path,'analysis')           % make the encoder-functions visible to matlab

A = double(imread('data/images/lena_small.tif'));
B = double(imread('data/images/lena.tif'));

% traing table
[Da, ~] = min_entropy_predictor(A, false);
H = hist(Da(:), -255:1:255);
H = H/sum(H);
Da_bias = 256;

[ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( H );

% encoding B
[Db, Db_size] = min_entropy_predictor(B, true);
Db_ch1 = Db(1:Db_size(1, 1),1:Db_size(2, 1), 1);
Db_ch2 = Db(1:Db_size(1, 2),1:Db_size(2, 2), 2);
Db_ch3 = Db(1:Db_size(1, 3),1:Db_size(2, 3), 3);
Db_source = round([Db_ch1(:); Db_ch2(:); Db_ch3(:)]);

bytestream = enc_huffman( (Db_source(:) + Da_bias), BinCode, Codelengths);
Reconstructed_D = double(reshape( dec_huffman ( bytestream, BinaryTree, max(size(Db_source(:))) ), size(Db_source))) - Da_bias;

%% reconstruct image
Db_reconst = zeros(size(Db));

ch1_end = (Db_size(1, 1)*Db_size(2, 1));
ch2_end = (Db_size(1, 2)*Db_size(2, 2))+ch1_end;
ch3_end = (Db_size(1, 3)*Db_size(2, 3))+ch2_end;
% 
Db_reconst(1:Db_size(1, 1),1:Db_size(2, 1), 1) = reshape(Reconstructed_D(1:ch1_end),...
    Db_size(1, 1), Db_size(2, 1));
Db_reconst(1:Db_size(1, 2),1:Db_size(2, 2), 2) = reshape(Reconstructed_D(ch1_end+1:ch2_end),...
    Db_size(1, 2), Db_size(2, 2));
Db_reconst(1:Db_size(1, 3),1:Db_size(2, 3), 3) = reshape(Reconstructed_D(ch2_end+1:ch3_end),...
    Db_size(1, 2), Db_size(2, 2));


% transform error to image
[h, w, d] = size(Db_reconst);
Sprime = Db_reconst;
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
        % recover Sprime
        Sprime(r, c, ch) = P + Db_reconst(r, c, ch);
    end
end
    
for ch = 2:1:d
    for r = 2:h/2
        for c = 2:w/2
            % elements used for prediction
            s123 = [Sprime(r, c-1, ch); Sprime(r-1, c-1, ch); Sprime(r-1, c, ch)];
            % prediction
            P = coef(ch, :) * s123;
            % recover Sprime
            Sprime(r, c, ch) = P + Db_reconst(r, c, ch);
        end
    end
end

Sprime_upsample = double(resample_ycbcr_decoder(Sprime));

figure
imagesc(B/256)

figure
imagesc(Sprime_upsample/256)
calcPSNR(B, Sprime_upsample, false)
