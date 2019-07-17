n_q = 0;
bitrates_rd_video = [];
psnrs_rd_video = [];
for qScale = 2:-0.2:0.2
    n_q = n_q + 1;
    optim_video;
    bitrates_rd_video(n_q) = mean(bitrates);
    psnrs_rd_video(n_q) = mean(psnrs);
end
figure;
plot(bitrates_rd_video, psnrs_rd_video,'rx-','MarkerSize',10);hold on;