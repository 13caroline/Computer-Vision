% gray scale
Path = 'images/';
Name = 'coins.jpg';

Image = imread(strcat(Path, Name));
Image_gray = im2double(rgb2gray(Image));

% main
%type_of_noise = 'gaussian';
type_of_noise = 'salt & pepper';

% Salt & Pepper Noise
noise_params.density = 0.01;

% Gaussian Noise
noise_params.mean = 0;
noise_params.var = 0.01;

% ------------------------------------------------------------------------

[noisy, peaksnr, snr, pre_processed, bw, coins, sizes, tipos, no_noise_seg] = main_image_recognition(Name, Image_gray, type_of_noise, noise_params);
disp('SNR: ');
disp(snr);
disp('Peak SNR: ');
disp(peaksnr);
disp('Number of coins: ');
disp(coins);
disp('Types: ');
disp(tipos);

figure(2), histogram(sizes);
figure(3), imshow(pre_processed); title('Pre Processed Image');
figure(4), imshow(bw); title('Segmented Image - Noise');
figure(5), imshow(no_noise_seg); title('Segmented Image - No Noise');

