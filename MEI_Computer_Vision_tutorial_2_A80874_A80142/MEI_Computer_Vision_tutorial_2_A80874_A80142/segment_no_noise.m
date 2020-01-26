function BW = segment_no_noise(gray_image, image_name)

if (strcmp(image_name, 'coins2.jpg') == 0)
    % Rescale
    [x, y] = size(gray_image);
    scl = x / y;
    gray_image = imresize(gray_image, [400 * scl, 400]);
end

if (strcmp(image_name, 'coins2.jpg'))
    gray_image = imadjust(gray_image);
    gray_image = medfilt2(gray_image, [3 3]);

    se = strel('disk', 30);
    gray_image = imcomplement(gray_image);
    background = imopen(gray_image, se);

    I = gray_image - background;
    I = imadjust(I);
    gray_image = I;


    % Filter image for easier edge detection
    m = 12;
    n = 12;
    img_filter = imfilter(gray_image, fspecial('average', [m n]));

    % Edge detection
    [~, threshold] = edge(img_filter, 'canny');
    fudgeFactor = 1.5;
    img_edge = edge(img_filter, 'canny', threshold * fudgeFactor);


    % Dilate image to make the coin edges complete without holes
    se_disk = strel('disk',4);
    se_line1 = strel('line',3,100);
    se_line2 = strel('line',3,100);
    img_dilated = imdilate(img_edge, se_disk);
    img_dilated = imdilate(img_dilated, [se_line1 se_line2]);


    % Remove stuff touching the image border and fill complete objects
    img_clearborder = imclearborder(img_dilated, 4);
    img_fill = imfill(img_clearborder, 'holes');

    % Erode image to make a clear cut between objects
    se_diamond = strel('diamond',2);
    img_erode = imerode(img_fill,se_diamond);
    for k=1:3
        img_erode = imerode(img_erode,se_diamond);
    end
    img_nosmall = bwareaopen(img_erode,200); % Remove small objects (noise)

    BW = img_nosmall;
   
elseif (strcmp(image_name, 'coins.jpg'))
    gray_image = imadjust(gray_image);
    smoothed_image = medfilt2(gray_image, [3 3]);

    
    % Deal with non uniform illumination
    se = strel('disk', 15);
    smoothed_image = imcomplement(smoothed_image);
    background = imopen(smoothed_image, se);
    
    I = smoothed_image - background;
    I = imadjust(I);
    
    I = histeq(I,256);
    
    se2 = strel('line', 5, 45);
    Ie = imerode(I, se2);
        
	se3 = strel('square', 5);
    Ie2 = imdilate(I, se3);
    Is = Ie2 -Ie;
    
    se4 = strel('disk', 4);
    Ie3 = imdilate(Is,se4);
    
    I = Ie3 - Is;
    
    I = rescale(I);
    
    % Threshold
    I2 = imbinarize(I,0.42);
    
    [~, threshold] = edge(I2, 'canny');
    fudgeFactor = 1.4;
    I2 = edge(I2, 'canny', threshold * fudgeFactor);
        
    % Removes objects with lower than N pixels
    BW = bwareaopen(I2, 100);
    BW = imclose(BW, strel('disk', 4));
    
    BW = imfill(BW, 'holes');
    
    BW = bwareaopen(BW, 200);
    
else 
    % Smooth filter 
    %smoothed_image = imgaussfilt(image_with_noise, 2); 
    gray_image = imadjust(gray_image);
    smoothed_image = medfilt2(gray_image, [3 3]);

    % Deal with non uniform illumination
    se = strel('disk', 30);
    smoothed_image = imcomplement(smoothed_image);
    background = imopen(smoothed_image, se);
    I = smoothed_image - background;
    I = imadjust(I);
    
    % Niblack's Threshold
    T = adaptthresh(I, 0.55);
    I2 = imbinarize(I,T);
    
    % Morphology
    % Adjust the contrast
    I3 = imadjust(uint8(I2));
    
    BW = imbinarize(I3);
    
    % Removes objects with lower than N pixels
    BW = bwareaopen(BW, 60);
    
    BW = imfill(BW, 'holes'); 
end
end