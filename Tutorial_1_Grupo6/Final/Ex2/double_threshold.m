function edges = double_threshold (gradient, T_Low, T_High)

    %Double Thresholding
    T_Low = T_Low * max(max(gradient));
    T_High = T_High * max(max(gradient));
    [x,y] = size(gradient);
    T_res = zeros (x, y);
    for i = 1:x
        for j = 1:y
            if (gradient(i, j) < T_Low)
                T_res(i, j) = 0;
            elseif (gradient(i, j) > T_High)
                T_res(i, j) = 1;
            else 
                T_res(i,j) = gradient(i,j) / 255;
            end
        end
    end
    edges = uint8(T_res.*255);
	
end