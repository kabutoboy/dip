I = imread("Chess_noise.pgm");
K = imread("Chess.pgm");
total_i = 6;
start_i = 1;
total_col = 6;
total_row = 1 + (2 * total_i) / total_col;
plot_count = 1;
for i = start_i:1:(start_i+total_i-1)  
  subplot(total_row, total_col, plot_count++);
  imshow(I);
end
[U V] = meshgrid(1:25);
for i = start_i:1:(start_i+total_i-1)  
  N = sqrt((U - 13).^2 + (V - 13).^2) <= i;
  J = medfilt2(I, N);
  subplot(total_row, total_col, plot_count++);
  imshow(N);
  subplot(total_row, total_col, plot_count++);
  imshow(J);
  fprintf("RMS error for J%d is %6.2f\n", i, sqrt(sum(sum(imsubtract(K, J).^2))/prod(size(I))));
end