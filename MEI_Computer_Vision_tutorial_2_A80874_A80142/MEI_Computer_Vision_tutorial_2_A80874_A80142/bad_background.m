function [pre_processed, BW, number_of_coins, sizes] = bad_background(img_gray)

    % Smooth filter 
    %smoothed_image = imgaussfilt(image_with_noise, 2); 
    img_gray = imadjust(img_gray);
    smoothed_image = medfilt2(img_gray, [3 3]);

    %figure(1), imshow(smoothed_image); title('Smoothed');
    
    % Deal with non uniform illumination
    se = strel('disk', 15);
    smoothed_image = imcomplement(smoothed_image);
    background = imopen(smoothed_image, se);
    %figure(3), imshow(background);title('background');
    
    I = smoothed_image - background;
    I = imadjust(I);
    
    pre_processed = I;
    %figure(4), imshow(I);title('Smoothed-BG');
    I = histeq(I,256);
    %figure(5), imshow(I);title('Hist EQ');
    
    se2 = strel('line', 5, 45);
    Ie = imerode(I, se2);
    %figure(6), imshow(Ie);title('Erode');
        
	se3 = strel('square', 5);
    Ie2 = imdilate(I, se3);
    %figure(8), imshow(Ie2);title('Dilate');
    Is = Ie2 -Ie;
    %figure(9), imshow(Is);title('Sub');

    se4 = strel('disk', 4);
    Ie3 = imdilate(Is,se4);
    %figure(10), imshow(Ie3);title('Dil2');

    I = Ie3 - Is;
    %figure(11), imshow(I);title('Sub2');

    I = rescale(I);
    
    % Threshold
    I2 = imbinarize(I,0.42);
    %figure(13), imshow(I2);title('Threshold');
    
    [~, threshold] = edge(I2, 'canny');
    fudgeFactor = 1.4;
    I2 = edge(I2, 'canny', threshold * fudgeFactor);
    %figure(20), imshow(I2);title('Canny');
        
    % Removes objects with lower than N pixels
    BW = bwareaopen(I2, 100);
    BW = imclose(BW, strel('disk', 4));
    %figure(14), imshow(BW);title('Binarize area open');
    
    BW = imfill(BW, 'holes');
    %figure(21), imshow(BW);title('Holes');
    
    BW = bwareaopen(BW, 200);
    %figure(22), imshow(BW);title('Open');
    
    % Hough Transform to find circles
   
    figure(), imshow(BW);
    
    % Image 2
    %[centers, radii, metric] = imfindcircles(BW,[20 50], 'ObjectPolarity', 'bright','Sensitivity', 0.87); % , 'EdgeThreshold', 0.5

    % Image 1 and 3
    [centers, radii, metric] = imfindcircles(BW,[30 90], 'ObjectPolarity', 'bright','Sensitivity', 0.87); % , 'EdgeThreshold', 0.5
    
    viscircles(centers, radii,'EdgeColor','b');
    
    % Count coins
    number_of_coins = length(centers);

    % Sizes of coins -> radii
    sizes = radii;

end