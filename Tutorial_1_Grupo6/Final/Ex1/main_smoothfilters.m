% type of noise: gaussian, salt & pepper
% noise_parameters: % of noise in image
% filtering domain = frequency, spatial
% type of smooth  
        % Spatial = average, gaussian, median 
        % Freq = gaussian, butterworth
% parameters  
        % width_of_filter 
        % standard_deviation -> gaussian, 
        % filter_order -> butterworth 
    
function [image_with_noise, smoothed_image] = main_smoothfilters (original_name, gray_image, type_of_noise, noise_parameters, filtering_domain, type_of_smoothing, filter_parameters)
    % Add noise to the original image, considering the type_of_noise and
    % the noise_parameters
    if strcmp(type_of_noise, 'salt & pepper')
        image_with_noise = imnoise(gray_image, type_of_noise, noise_parameters.density);
    elseif strcmp(type_of_noise, 'gaussian')
        image_with_noise = imnoise(gray_image, type_of_noise, noise_parameters.mean, noise_parameters.var);
    end
    strparams = '';
    if strcmp(filtering_domain, 'spatial')
        if strcmp(type_of_smoothing, 'gaussian')
            % Gaussian
            strparams = strcat('W', num2str(filter_parameters.width_of_filter), 'SD', num2str(filter_parameters.standard_deviation));
            kernel = fspecial(type_of_smoothing, [filter_parameters.width_of_filter filter_parameters.width_of_filter], filter_parameters.standard_deviation);
            smoothed_image = imfilter(image_with_noise, kernel); 
        elseif strcmp(type_of_smoothing, 'average')
            % Average
            strparams = strcat('W', num2str(filter_parameters.width_of_filter));
            kernel = ones(filter_parameters.width_of_filter, filter_parameters.width_of_filter) / (filter_parameters.width_of_filter * filter_parameters.width_of_filter);
            smoothed_image = imfilter(image_with_noise, kernel);
        elseif strcmp(type_of_smoothing, 'median') 
            % Median
            strparams = strcat('W', num2str(filter_parameters.width_of_filter));
            smoothed_image = medfilt2(image_with_noise, [filter_parameters.width_of_filter filter_parameters.width_of_filter]);
        end 
    elseif strcmp(filtering_domain, 'frequency')
        [M,N] = size(image_with_noise);
        %figure(10), imshow(image_with_noise); title('Noise');
        
        % Padding 
        P = 2*M;
        Q = 2*N;
        
        % Zero Padding
        padded_image = zeros(P,Q);
        for i = 1:P
            for j = 1:Q
                if i <= M && j <= N
                    padded_image(i,j) = image_with_noise(i,j);
                else
                    padded_image(i,j) = 0;
                end
            end
        end
        %figure(11), imshow(padded_image);title('Padded');
        % Centering
        centered_image = zeros(P,Q);
        % Multiplying the padded image with (-1)^(x+y) - Centering to
        % simplify operation with H
        for i = 1:P
            for j = 1:Q
                centered_image(i,j) = padded_image(i,j).*(-1).^(i + j);
            end
        end
        %figure(12), imshow(centered_image);title('Centered');
        % DFT of image
        F = fft2(centered_image);
        %figure(13), imshow(F);title('DFT');
        
        if strcmp(type_of_smoothing, 'gaussian')
            strparams = strcat('SD', num2str(filter_parameters.standard_deviation));
            H = zeros(P,Q); % Centered in (P/2, Q/2)
            D0 = filter_parameters.standard_deviation;
            for u = 1:P
                for v = 1:Q
                    D = sqrt((u - (P/2))^2 + (v - (Q/2))^2);
                    H(u,v) = 255*exp((-(D^2))/(2*D0.^2));
                end
            end
            %figure(14), imshow(H);title('Filter');
            
            G = F.*H;
            %figure(15), imshow(G);title('G');
        elseif strcmp(type_of_smoothing, 'butterworth')
            H = zeros(P,Q); % Centered in (P/2, Q/2)
            Order = filter_parameters.filter_order;
            D0 = filter_parameters.diameter;
            strparams = strcat('O', num2str(Order), 'D', num2str(D0));
            for u = 1:P
                for v = 1:Q
                    D = sqrt((u - (P/2))^2 + (v - (Q/2))^2);
                    H(u,v) = 255*(1/(1 + (D/D0).^2*Order));
                end
            end
            %figure(14), imshow(H);title('Filter');
            
            G = F.*H;
            %figure(15), imshow(G);title('G');
            
        end
        % IDFT
        IDFT = uint8(real(ifft2(G)));
        %figure(16), imshow(IDFT);title('IDFT');
        % Descentered Image
        descentered_image = zeros(P,Q);
        for i = 1:P
            for j  = 1:Q
                descentered_image(i,j) = IDFT(i,j).*(-1).^(i + j);
            end    
        end
        %figure(17), imshow(uint8(descentered_image));title('Descentered');
        
        % Cropp image - top left quadrant
        smoothed_image = zeros(M,N);
        for i = 1:M
            for j = 1:N
                smoothed_image(i,j) = descentered_image(i,j);
            end
        end
        smoothed_image = uint8(smoothed_image);
    end
    imwrite(smoothed_image, strcat('out/', original_name, '_smooth_', type_of_smoothing, '_', strparams, '.png'));
end