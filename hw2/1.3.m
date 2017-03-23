I = imread("Cross.pgm");
I = imrotate(I, 30);
F = fft2(I, 256, 256);
F = fftshift(F); % Center FFT
F1 = abs(F); % Get magnitude
F1 = log(F1+1); % Use log, for perceptual scaling, and +1 since log(0) is undefined
F1 = mat2gray(F1); % Use mat2gray to scale between 0 and 1
F2 = angle(F);
#F2 = log(F2+1);
F2 = mat2gray(F2);
subplot(1, 3, 1);
imshow(I);
subplot(1, 3, 2);
imshow(F1);
subplot(1, 3, 3);
imshow(F2);
