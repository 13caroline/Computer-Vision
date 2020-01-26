function [image_with_noise, peaksnr, snr, pre_processed, BW, number_of_coins, sizes, tipos, no_noise_seg] = main_image_recognition (image_name, gray_image, type_of_noise, noise_parameters)

if (strcmp(image_name, 'coins2.jpg') == 0)
    % Rescale
    [x, y] = size(gray_image);
    scl = x / y;
    gray_image = imresize(gray_image, [400 * scl, 400]);
end
% Adding noise to the image
if strcmp(type_of_noise, 'salt & pepper')
        image_with_noise = imnoise(gray_image, type_of_noise, noise_parameters.density);
    elseif strcmp(type_of_noise, 'gaussian')
        image_with_noise = imnoise(gray_image, type_of_noise, noise_parameters.mean, noise_parameters.var);
end

% SNR and Peak SNR
[peaksnr, snr] = psnr(image_with_noise, gray_image);

if (strcmp(image_name, 'coins2.jpg'))
    [pre_processed, BW, number_of_coins, sizes] = shadows_occlusion(image_with_noise);
    tipos = types(sizes, image_name);
elseif (strcmp(image_name, 'coins.jpg'))
    [pre_processed, BW, number_of_coins, sizes] = bad_background(image_with_noise);
    tipos = types(sizes, image_name);
else 
    % Smooth filter 
    %smoothed_image = imgaussfilt(image_with_noise, 2); 
    image_with_noise = imadjust(image_with_noise);
    smoothed_image = medfilt2(image_with_noise, [3 3]);

    %figure(1), imshow(smoothed_image); title('Smoothed');

    % Normalization - rescale normalizes image beetween 0 and 1
    %smoothed_image = rescale(smoothed_image);
    %figure(2), imshow(smoothed_image); title('Smoothed rescaled');

    % Deal with non uniform illumination
    se = strel('disk', 30);
    %se = strel('disk', 10);
    smoothed_image = imcomplement(smoothed_image);
    background = imopen(smoothed_image, se);
    %figure(3), imshow(background);title('background');
    %se = strel('disk', 60);
    %smoothed_image = imcomplement(smoothed_image);
    %I = imtophat(smoothed_image, se);
    %I = imadjust(I);
    I = smoothed_image - background;
    I = imadjust(I);
    %figure(4), imshow(I);title('Illumination equalization');
    
    pre_processed = I;

    % Niblack's Threshold
    T = adaptthresh(I, 0.55);
    I2 = imbinarize(I,T);
    %figure(5), imshow(I2);title('Niblack');

    % Morphology
    % Adjust the contrast
    I3 = imadjust(uint8(I2));
    %figure(6), imshow(I3);title('Adjust');

    BW = imbinarize(I3);
    %figure(7), imshow(BW);title('Binarize');

    % Removes objects with lower than N pixels
    BW = bwareaopen(BW, 60);
    %figure(8), imshow(BW);title('Binarize area open');

    BW = imfill(BW, 'holes');
    %figure(9), imshow(BW);title('Fill');
    
    % Hough Transform to find circles
    % A = imcomplement(A);
    % BW = bwperim(BW);
    % BW = imfill(BW, 'holes');
    %BW = edge(BW, 'Canny');
    %figure(10), imshow(BW);title('Canny');

    figure(), imshow(BW);
    %[centers, radii, metric] = imfindcircles(BW,[30 90],'Sensitivity', 0.90);

    % Image 2
    %[centers, radii, metric] = imfindcircles(BW,[20 50], 'ObjectPolarity', 'bright','Sensitivity', 0.87); % , 'EdgeThreshold', 0.5

    % Image 1 and 3
    [centers, radii, metric] = imfindcircles(BW,[30 90], 'ObjectPolarity', 'bright','Sensitivity', 0.87); % , 'EdgeThreshold', 0.5
    %[centers_bright, radii_bright, metric_bright] = imfindcircles(BW,[30 90], 'ObjectPolarity', 'dark','Sensitivity', 0.90); % , 'EdgeThreshold', 0.5

    viscircles(centers, radii,'EdgeColor','b');
    %viscircles(centers_bright, radii_bright,'EdgeColor','r');

    % Count coins
    number_of_coins = length(centers);

    % Sizes of coins -> radii
    sizes = radii;
    
    tipos = types(sizes, image_name);
end
no_noise_seg = segment_no_noise(gray_image, image_name);

end