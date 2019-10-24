% Método Gaussiano para remover ruído Salt and Pepper
I = imread('imdata/eight.tif');
J = imnoise(I, 'salt & pepper', 0.02);
figure(1), imshow(J);

h = fspecial('gaussian', [3 3], 0.5);
L = imfilter(J,h);
figure(2), imshow(L);

k = [1 1 1 ; 1 1 1; 1 1 1]/9; % Filtro atenuizador com carateristicas de passa baixo -> Soma = 1

figure(3), freqz2(k);
M = imfilter(J,k);
figure(4), imshow(M);

% Método Mediana
K = medfilt2(J, [3 3]);
figure(5), imshow(K);

% [x x x x x x x x] Menor para Maior > valores baixos ruido preto incluido,
% valores alto rucído branco incluido, Meio valores atenuizadores
Y = ordfilt2(J, 5, ones(3,3));
figure(6), imshow(Y);