function enhanced_image = nonmax (magnitude, orientation)
    [x,y] = size(orientation);
    enhanced_image = zeros(x, y);

    orientation2=zeros(x, y);

    %Adjusting directions to nearest 0, 45, 90, or 135 degree
    for i = 1:x
        for j = 1:y
            if ((orientation(i, j) >= 0 ) && (orientation(i, j) < 22.5) || (orientation(i, j) >= 157.5) && (orientation(i, j) < 202.5) || (orientation(i, j) >= 337.5) && (orientation(i, j) <= 360))
                orientation2(i, j) = 0;
            elseif ((orientation(i, j) >= 22.5) && (orientation(i, j) < 67.5) || (orientation(i, j) >= 202.5) && (orientation(i, j) < 247.5))
                orientation2(i, j) = 45;
            elseif ((orientation(i, j) >= 67.5 && orientation(i, j) < 112.5) || (orientation(i, j) >= 247.5 && orientation(i, j) < 292.5))
                orientation2(i, j) = 90;
            elseif ((orientation(i, j) >= 112.5 && orientation(i, j) < 157.5) || (orientation(i, j) >= 292.5 && orientation(i, j) < 337.5))
                orientation2(i, j) = 135;
            end
        end
    end
    orientation = orientation2;
        
    %Non-Maximum Supression - Slide 47
    for i=2:x-1
        for j=2:y-1
            if (orientation(i,j)==0)
                enhanced_image(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i,j+1), magnitude(i,j-1)]));
            elseif (orientation(i,j)==45)
                enhanced_image(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j-1), magnitude(i-1,j+1)]));
            elseif (orientation(i,j)==90)
                enhanced_image(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j), magnitude(i-1,j)]));
            elseif (orientation(i,j)==135)
                enhanced_image(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j+1), magnitude(i-1,j-1)]));
            end
        end
    end
    enhanced_image = enhanced_image.*magnitude;
    
end