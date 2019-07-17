load psnrs_base.mat;
load bitrates_base.mat;
hold on;
plot(bitrates_base, psnrs_base,'bx-','MarkerSize',10);