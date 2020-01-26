Path = 'images/';
Name = 'baboon.png';

Image = imread(strcat(Path, Name));
Image_gray = im2double(rgb2gray(Image));

type_of_noise = 'gaussian';

% Salt & Pepper Noise
noise_params.density = 0.02;

% Gaussian Noise
noise_params.mean = 0;
noise_params.var = 0.01;

domain = 'frequency';
filter = 'gaussian';

filter_parameters.width_of_filter = 3;
% Gaussian(image, sdv)
filter_parameters.standard_deviation = 100;

% Butterworth(image, diameter, order)
filter_parameters.filter_order = 50; 
filter_parameters.diameter = 25;

% ------------------------------------------------------------------------
[noisy, smoothed] = main_smoothfilters(Name, Image_gray, type_of_noise, noise_params, domain, filter, filter_parameters);
figure(2), imshow(noisy); title('Noisy Image');
figure(3), imshow(smoothed); title('Smoothed Image');
