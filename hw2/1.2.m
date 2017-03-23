I = imread("Cross.pgm");
F = fft2(I, 256, 256);
#F = fftshift(F); % Center FFT
F1 = abs(F);
F2 = angle(F);
F2 *= 2+2*i;
H = F1 .* exp(i*F2);
J = ifft2(H);
subplot(1, 3, 1);
imshow(I);
subplot(1, 3, 2);
imshow(F2);
subplot(1, 3, 3);
imshow(J);
