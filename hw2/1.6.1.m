I = imread("Lenna.pgm");
F = fft2(I, 256, 256);
#F = fftshift(F); % Center FFT
F1 = abs(F);
F2 = angle(F);
H = exp(i*F2);
J = ifft2(H);
subplot(1, 2, 1);
imshow(I);
subplot(1, 2, 2);
imshow(J);
