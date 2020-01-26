% script
Path = 'images/';
Name = 'castle.png';
Image = imread(strcat(Path, Name));
Image_gray = im2double(rgb2gray(Image));

image_with_noise = imnoise(Image_gray, 'gaussian', 0, 0.02);

filter_size = 5;
standard_deviation = 3;

% ------------------------------------------------------------------------
[before_nonmax, after_nonmax, after_hysteresis] = main_CannyDetector(image_with_noise, Name, filter_size, standard_deviation);
figure(1), imshowpair(before_nonmax, after_nonmax, 'montage'); title('Before Non-Max (Left) and After Non-Max (Right)');
figure(2), imshowpair(after_nonmax, after_hysteresis, 'montage'); title('After Non-Max (Left) and After Hysteresis (Right)');
