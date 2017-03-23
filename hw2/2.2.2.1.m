I = imread("Lenna_noise.pgm");
K = imread("Lenna.pgm");
subplot(4, 3, 1);
imshow(I);
subplot(4, 3, 2);
imshow(I);
subplot(4, 3, 3);
imshow(I);
F = fft2(I, 256, 256);
F = fftshift(F);
G1 = fspecial("gaussian", 256, 16);
G2 = fspecial("gaussian", 256, 24);
G3 = fspecial("gaussian", 256, 32);
G1 /= max(max(G1));
G2 /= max(max(G2));
G3 /= max(max(G3));
subplot(4, 3, 4);
imshow(G1);
subplot(4, 3, 5);
imshow(G2);
subplot(4, 3, 6);
imshow(G3);
F1 = F .* G1;
F2 = F .* G2;
F3 = F .* G3;
subplot(4, 3, 7);
imshow(log(1+abs(F1)));
subplot(4, 3, 8);
imshow(log(1+abs(F2)));
subplot(4, 3, 9);
imshow(log(1+abs(F3)));
F1 = ifftshift(F1);
F2 = ifftshift(F2);
F3 = ifftshift(F3);
J1 = uint8(real(ifft2(F1)));
J2 = uint8(real(ifft2(F2)));
J3 = uint8(real(ifft2(F3)));
subplot(4, 3, 10);
imshow(J1);
subplot(4, 3, 11);
imshow(J2);
subplot(4, 3, 12);
imshow(J3);

fprintf("RMS error for J1 is %6.2f\n", sqrt(sum(sum(imsubtract(K, J1).^2))/prod(size(I))));
fprintf("RMS error for J2 is %6.2f\n", sqrt(sum(sum(imsubtract(K, J2).^2))/prod(size(I))));
fprintf("RMS error for J3 is %6.2f\n", sqrt(sum(sum(imsubtract(K, J3).^2))/prod(size(I))));