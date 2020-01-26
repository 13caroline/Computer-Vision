function [pre_processed, BW, number_of_coins, sizes] = shadows_occlusion(img_gray)

img_gray = imadjust(img_gray);
img_gray = medfilt2(img_gray, [3 3]);

se = strel('disk', 30);
img_gray = imcomplement(img_gray);
background = imopen(img_gray, se);

I = img_gray - background;
I = imadjust(I);
img_gray = I;


% Filter image for easier edge detection
m = 12;
n = 12;
img_filter = imfilter(img_gray, fspecial('average', [m n]));

pre_processed = img_filter;

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


[x, y] = size(img_nosmall);
scl = x / y;
img_nosmall = imresize(img_nosmall, [400 * scl, 400]);


figure(), imshow(img_nosmall);
[centers, radii, metric] = imfindcircles(img_nosmall,[20 60], 'ObjectPolarity', 'bright','Sensitivity', 0.91); 

viscircles(centers, radii,'EdgeColor','r');

% Count coins
number_of_coins = length(centers);

% Sizes of coins -> radii
sizes = radii;

end