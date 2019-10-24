% 1
I = imread('imdata/lena.jpg');
J = rgb2gray(I);
figure(1), imshow(J);

% 2
K = imnoise(J, 'salt & pepper', 0.02);
figure(2), imshow(K);

L = imnoise(J, 'gaussian', 0.02);
figure(3), imshow(L);

% 3
my_imfiler(3,K);
my_imfiler(3,L);
my_imfiler(3,J);

% 4
% Imfilter - CORRELACAO
k = [1 1 1 ; 1 1 1; 1 1 1]/9; % Filtro atenuizador com carateristicas de passa baixo -> Soma = 1
M = imfilter(K,k);
figure(7), imshow(M);

M2 = imfilter(L,k);
figure(8), imshow(M2);

%CONVULSAO
C = conv2(K,k);
figure(9), imshow(uint8(C));

C2 = conv2(L,k);
figure(10), imshow(uint8(C2));

% 5
ga = fspecial('gaussian', [3 3], 0.5);
N = imfilter(K,ga);
figure(11), imshow(N);

N2 = imfilter(L,ga);
figure(12), imshow(N2);

% 6
% Kernel maior > + desfocado
% Sigma maior > + desfocado
% Kernel = 5
% Sigma = 2
g2 = fspecial('gaussian', [5 5], 2);
I52 = imfilter(K,g2);
figure(13), imshow(I52);

% Sigma = 5
g5 = fspecial('gaussian', [5 5], 5);
I55 = imfilter(K,g5);
figure(14), imshow(I55);

% Sigma = 10
g10 = fspecial('gaussian', [5 5], 10);
I510 = imfilter(K,g10);
figure(15), imshow(I52);

% Kernel = 10
%Sigma = 2
g102 = fspecial('gaussian', [10 10], 2);
I102 = imfilter(K,g102);
figure(16), imshow(I102);

% 7
% zero padding (Black border) - 
ZP = imfilter(K,k);
figure(17), imshow(ZP);
% Replicate Boundary - 
RB = imfilter(K,k,'replicate');
figure(18), imshow(RB);
% Replicate Boundary - 
SM = imfilter(K,k,'symmetric');
figure(19), imshow(SM);
% Replicate Boundary - 
CR = imfilter(K,k,'circular');
figure(20), imshow(CR);

% 8 
% Método Mediana - Muito melhor para ruído
Med = medfilt2(K, [3 3]);
figure(21), imshow(Med);

% 9
% Filtro Passa Alto
%I9 = imsharpen(J);
%figure(22), imshow(I9);

filter_matrix = fspecial('Gaussian', 5, 1);
I_filtered = J - imfilter(J, filter_matrix);
figure(22), imshow(I_filtered);

% Soma da original com a laplaciana da gaussiana
h1 = fspecial('laplacian',0.2);
fil_I2 = J - imfilter(J, h1);
figure(23), imshow(fil_I2);