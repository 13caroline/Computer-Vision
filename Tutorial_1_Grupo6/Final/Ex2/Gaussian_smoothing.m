function smoothed_image = Gaussian_smoothing (image_with_noise, kernel_size, standard_deviation)
    kernel = fspecial('gaussian', [kernel_size kernel_size], standard_deviation);
    smoothed_image = imfilter(image_with_noise, kernel);
end