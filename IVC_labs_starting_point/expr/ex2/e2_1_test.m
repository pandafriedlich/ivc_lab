
%% compute entropy for every single image
lena = double(imread('lena.tif'));
sail = double(imread('sail.tif'));
smandril = double(imread('smandril.tif'));

pmf_lena = stats_marg(lena);
pmf_sail = stats_marg(sail);
pmf_smandril = stats_marg(smandril);

H_lena = calc_entropy(pmf_lena);
H_sail = calc_entropy(pmf_sail);
H_smandril = calc_entropy(pmf_smandril);

fprintf(1, "-------------------------------------------------------------\n");
fprintf(1, "H_lena:\t %.4f bps\nH_sail:\t %.4f bps\nH_smandril:\t %.4f bps\n",...
    H_lena, H_sail, H_smandril);
fprintf(1, "-------------------------------------------------------------\n");

%% estimate the PMF by 3 images together
pmf_together = stats_marg(lena, sail, smandril);

H_lena_t = calc_entropy(pmf_lena, pmf_together);
H_sail_t = calc_entropy(pmf_sail, pmf_together);
H_smandril_t = calc_entropy(pmf_smandril, pmf_together);

fprintf(1, "-------------------------------------------------------------\n");
fprintf(1, "H_lena_t:\t %.4f bps\nH_sail_t:\t %.4f bps\nH_smandril_t:\t %.4f bps\n",...
    H_lena_t, H_sail_t, H_smandril_t);
fprintf(1, "-------------------------------------------------------------\n");

%% difference
fprintf(1, "-------------------------------------------------------------\n");
fprintf(1, "delta H_lena:\t %.4f bps\ndelta H_sail:\t %.4f bps\ndelta H_smandril:\t %.4f bps\n",...
    H_lena_t-H_lena, H_sail_t-H_sail, H_smandril_t-H_smandril);
fprintf(1, "-------------------------------------------------------------\n");

