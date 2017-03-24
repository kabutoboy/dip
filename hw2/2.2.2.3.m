wb = waitbar(0, 'Loading images...');
I = imread("Lenna_noise.pgm");
K = imread("Lenna.pgm");
np2 = 2.^nextpow2(max(size(I)));
F = fft2(I, np2, np2);
F = fftshift(F);
total_n = 3;
total_i = 3;
start_n = 1;
start_i = 18;
plot_count = 1;
for i = 1:1:(2*total_i)
  subplot(1+total_n, 2*total_i, plot_count);
  imshow(I);
  plot_count++;
end
[U V] = meshgrid(1:np2);
ONES = ones(np2, np2);
for n = start_n:1:(start_n+total_n-1)
  for i = start_i:1:(start_i+total_i-1)
    progress = (plot_count) ./ ((2*total_i)*(1+total_n));
    waitbar(progress, wb, strcat('Processing... (', int2str(int8(100 * progress)), '%)'));
    H = ONES ./ (1 + (sqrt((U - np2/2).^2 + (V - np2/2).^2) ./ i).^(2*n));
    subplot(1+total_n, 2*total_i, plot_count);
    imshow(H);
    plot_count++;
    #imshow(H);
    J = uint8(real(ifft2(ifftshift(F .* H))));
    fprintf("RMS error for J_%d_%d is %6.2f\n", n, i, sqrt(sum(sum(imsubtract(K, J).^2))/prod(size(I))));
    subplot(1+total_n, 2*total_i, plot_count);
    imshow(J);
    plot_count++;
  end
end
close(wb);