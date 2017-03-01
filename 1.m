I = imread("scaled_shapes.pgm");
h = zeros(1, 256);
for i = 1:size(I)(1)
  for j = 1:size(I)(2)
    d = 1 + I(i, j);
    h(d)++;
  end
end
x = 1:1:256;
plot(x, h);