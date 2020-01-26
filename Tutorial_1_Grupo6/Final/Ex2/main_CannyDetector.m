function [before_nonmax, after_nonmax, after_hysteresis] = main_CannyDetector (image_with_noise, original_name, filter_size, standard_deviation)
    smoothed_image = Gaussian_smoothing(image_with_noise, filter_size, standard_deviation);
    
    [Gx, Gy, before_nonmax, Dir] = gradient(smoothed_image);
    imwrite(before_nonmax, strcat('out/',original_name, '_edge_canny_', num2str(filter_size), '_', num2str(standard_deviation), '.png'));
    
    after_nonmax = nonmax(before_nonmax, Dir);
    imwrite(after_nonmax, strcat('out/', original_name, '_edge_canny_nonmax_', num2str(filter_size), '_', num2str(standard_deviation), '.png'));
    
    double_thresh = double_threshold(after_nonmax, 0.075, 0.175);
    
    after_hysteresis = hysteresis_thresholding(double_thresh);
    imwrite(after_hysteresis, strcat('out/', original_name, '_edge_canny_hysteresis_', num2str(filter_size), '_', num2str(standard_deviation), '.png'));
end