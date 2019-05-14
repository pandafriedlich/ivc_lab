clear;clc;
lena = double(imread('lena.tif'));

%% 1st order prediction
a1 = 1;
[h, w, d] = size(lena); 
mu_p = zeros(h, w, d);
e = zeros(h, w, d);


for ch = 1:1:d
    mu_p(:, :, ch) =  [zeros(h, 1), lena(:, 1:end-1, ch)]; % prediction
    e(:, :, ch) = lena(:,:, ch) - mu_p(:, :, ch);          % error singal
end
% error PMF
l = min(min(min(e))); h = max(max(max(e)));
e_pmf = hist(e(:), l:h);
e_pmf = e_pmf/sum(e_pmf); 
% error entropy
ent_e = calc_entropy(e_pmf);
fprintf(1, 'Error entropy(1st order linear): %.4f [bps]\n', ent_e);


%% minimum-entropy predictor
S = ictRGB2YCbCr(lena);
[h, w, d] = size(S);

D = round(S);
Sprime = D;

coef = [7/8, -1/2, 5/8; %Y
    3/8, -1/4, 7/8; %Cb
    3/8, -1/4, 7/8; %Cb
    ];


for ch = 1:1:d
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
end

lb = min(min(min(D))); hb = max(max(max(D)));
D_pmf = hist(D(:), lb:hb);
D_pmf = D_pmf/sum(D_pmf); 

ent_D = calc_entropy(D_pmf);
fprintf(1, 'Error entropy(minimum entropy): %.4f [bps]\n', ent_D);

%% 
[ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman(D_pmf);
ylabel('Code Lengths');
plot(Codelengths);
yyaxis right;
ylabel('PMF');
plot(D_pmf);
fprintf(1, 'min CL: %d\t max CL: %d\n', min(Codelengths),max(Codelengths));
grid on;


