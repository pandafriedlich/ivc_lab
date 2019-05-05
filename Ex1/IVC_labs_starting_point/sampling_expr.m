
clc;
W = [1, 2, 1;
        2, 4, 2;
        1, 2, 1];
% 
% W = fir1(40, 0.5)'*fir1(40, 0.5); 

figure;
imagesc( abs( fftshift(fft2(W))));
colorbar;

satpic = double(imread('satpic1.bmp'));

prefilter = 1;
if prefilter
    disp('Prefiltered');
    img_filtered = prefilterlowpass2d(satpic, W);
else
    
    disp('Not Prefiltered');
    img_filtered = satpic;
end
% disp('Filtering Quality;');
% calcPSNR(satpic, img_filtered, 0);
% figure;
% subplot(121)
% imshow(satpic/255);
% title('raw');
% subplot(122);
% imshow(img_filtered/255);
% title('prefiltered');

[h, w, d] = size(img_filtered);
downsampled_img = zeros(h/2, w/2, d);

for ch = 1 :d  
    downsampled_img(:, :, ch) = downsample( downsample(img_filtered(:,:,ch), 2)', 2)';
end




upsampled_img = zeros(h, w, d);
for ch = 1 :d  
    upsampled_img(:, :, ch) = upsample(upsample(downsampled_img(:,:,ch), 2)', 2)';
end

upsampled_img_filtered = 4 * prefilterlowpass2d(upsampled_img, W);
% figure;
% subplot(221);
% imshow(img_filtered/255);
% title('prefiltered');
% 
% subplot(222)
% imshow(downsampled_img/255);
% title('downsampled');
% subplot(223)
% imshow(upsampled_img/255);
% title('upsampled');
% 
% subplot(224)
% imshow(upsampled_img_filtered/255);
% title('post-filtered');
figure;
imshow(upsampled_img_filtered/255);
title("post-filtered" + num2str(size(W)));
calcPSNR(satpic, upsampled_img_filtered, 0);