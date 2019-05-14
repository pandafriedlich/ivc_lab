clear; clc;

lena = double(imread('lena.tif'));

joint_pmf = stats_joint(lena, false);
joint_ent = calc_entropy2d(joint_pmf);
fprintf(1, 'Joint entropy: %.4f [bps]\n', joint_ent);


[joint_pmf, cond_pmf] = stats_cond(lena);
cond_ent = calc_condent(joint_pmf, cond_pmf);
fprintf(1, 'Conditional entropy: %.4f [bps]\n', cond_ent);