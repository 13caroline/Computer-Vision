function final_edge_map = hysteresis_thresholding (edges)

    % Hysteresis Thresholding
    [x,y] = size(edges);
    T_res = zeros(x, y);
    for i = 2:x-1 
        for j = 2:y-1
            % 8-connected components
            if (edges(i - 1, j - 1) == 255 || edges(i, j - 1) == 255 || edges(i + 1, j - 1) == 255 || edges(i - 1, j) == 255 || edges(i + 1, j) == 255 || edges(i - 1, j + 1) == 255 || edges(i, j + 1) == 255 || edges(i + 1, j + 1) == 255)  
                T_res(i,j) = edges(i,j); % If the blob contains at least one strong edge pixel, then it's preserved
            else 
                T_res(i,j) = 0; % Otherwise it's suppressed
            end 
        end
    end
    final_edge_map = uint8(T_res);
end