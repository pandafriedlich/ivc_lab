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
e_pmf = stats_marg(e, false);
% error entropy
ent_e = calc_entropy(e_pmf);
fprintf(1, 'Error entropy(1st order linear): %.4f [bps]\n', ent_e);


%% minimum-entropy predictor
D = min_entropy_predictor(lena, false);
D_pmf = stats_marg(D, false); 
ent_D = calc_entropy(D_pmf);
fprintf(1, 'Error entropy(minimum entropy): %.4f [bps]\n', ent_D);

%% 
[ BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman(D_pmf);
ylabel('Code Lengths');
plot(Codelengths);
yyaxis right;
ylabel('PMF');
plot(D_pmf);
fprintf(1, 'min CL: %d\t max CL: %d\t number of codes: %d\n',...
    min(Codelengths),max(Codelengths),length(Codelengths));
grid on;


