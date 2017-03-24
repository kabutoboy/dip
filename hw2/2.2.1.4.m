wb = waitbar(0, 'Loading images...');
I = imread("Chess_noise.pgm");
K = imread("Chess.pgm");
np2 = 2.^nextpow2(max(size(I)));
F = fft2(I, np2, np2);
F = fftshift(F);
total_i = 9;
start_i = 30;
plot_count = 1;
total_col = 6;
total_row = 1 + (2*total_i) / total_col;
for i = 1:1:total_col
  subplot(total_row, total_col, plot_count);
  imshow(I);
  plot_count++;
end
[U V] = meshgrid(1:np2);
ONES = ones(np2, np2);
for i = start_i:1:(start_i+total_i-1)
  progress = (plot_count) ./ ((total_col)*(total_row));
  waitbar(progress, wb, strcat('Processing... (', int2str(int8(100 * progress)), '%)'));
  H = exp(-((U - np2/2).^2 + (V - np2/2).^2) ./ (2 * i^2));
  subplot(total_row, total_col, plot_count);
  imshow(H);
  plot_count++;
  #imshow(H);
  J = uint8(real(ifft2(ifftshift(F .* H))));
  fprintf("RMS error for J_%d is %6.2f\n", i, sqrt(sum(sum(imsubtract(K, J).^2))/prod(size(I))));
  subplot(total_row, total_col, plot_count);
  imshow(J);
  plot_count++;
end
close(wb);