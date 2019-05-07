clear all;

bps = [12, 6, 8, 8, 8];
psnrs = [46.2606, 26.8587, 21.2321, 17.05, 15.49];
names = {'sail.tif - Chrominance subsampling',
    'sail.tif - RGB-subsampling(CIF)',
    'sail.tif - starting algorithm',
    'smandril.tif - starting algorithm',
    'lena.tif - starting algorithm'};

figure;
plot(bps, psnrs, 'o');
xlabel("Bit per pixel");
ylabel("PSNR/dB");
grid on;
axis([0, 25, 10, 50]);

offset = .5;
for i = 1:length(bps)
    text(bps(i)+offset, psnrs(i), names(i));
end

