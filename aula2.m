I = imread('imdata\castle.png', 'png'); % 512 x 512 x 3
figure(1), imshow(I);
img_gray = rgb2gray(I); % 512 x 512
figure(2), imshow(img_gray);
% Saving new image
%imwrite(img_gray,'castleGray.jpg','jpg');

% Gera imagem mais escura, remove componentes brilhantes
avg = uint8 (mean(mean(I)))
img_ft=I-avg;
img_ft(img_ft<=0)=0; % Evitar valores negativos
figure(3), imshow(img_ft);

B = im2double(I); % converte imagem para double
figure(4), imhist(B, 256); % Histograma

D = imadjust(B, [0 1],[1 0]); % Cria b«negativo da imagem
figure(5), imshow(D); % MOstra negativa

E = histeq(B); % Melhora contraste 
figure(6), imshow(E); % Mostra figure com melhor contraste

F = graythresh(B) % Calcula nivel de threshold

G = im2bw(B,F); % Converte imagem conzenta para binario tendo em conta o TH
figure(7), imshow(G); % Mostra imagem binaria

figure(8), build_histogram(img_gray);

% Comparar fig 2 com fig 9
figure(9), histeq(img_gray)


imshow(I);
figure(10), imhist(I);
ylim('auto');

GG = histeq(I, 256);
figure(11), imshow(GG);
figure(12), imhist(GG); % Escurece os pontos escuros e clareia os claros
ylim('auto');
