function [Gx, Gy, magnitude, orientation] = gradient (image)
	
    % Sobel's - Vertical and Horizontal
    KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];

    % Convolution by image by horizontal and vertical filter
    Gx = conv2(image, KGx, 'same');
    Gy = conv2(image, KGy, 'same');
    
    % Orientations
    orientation = atan2(Gy, Gx);
    orientation = orientation*180/pi;
    [x, y]=size(image);
    
    % Adjustment for negative directions, making all directions positive
    for i=1:x
        for j=1:y
            if (orientation(i,j)<0) 
                orientation(i,j)=360+orientation(i,j);
            end
        end
    end

    % Magnitude
    magnitude = sqrt((Gx.^2) + (Gy.^2));
end