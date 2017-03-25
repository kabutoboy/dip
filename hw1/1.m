function m = M(p, q, x_bar, y_bar, f)
  [X Y] = meshgrid(1:size(f)(2), 1:size(f)(1));
  m = sum(sum((X-x_bar).^p .* (Y-y_bar).^q .* f));
end

I = imread("scaled_shapes.pgm");
h = zeros(1, 256);
for i = 1:size(I)(1)
  for j = 1:size(I)(2)
    d = 1+int16(I(i, j));
    h(d)++;
  end
end
x = 0:1:255;
subplot(4, 2, 1);
imshow(I);
subplot(4, 2, 2);
plot(x, h);
peaks = (h > 1000);
objects = logical(zeros(size(I)(1), size(I)(2), sum(peaks)));
thresh = 2;
count = 1;
for d = 1:length(peaks)
  if (peaks(d) == 0)
    continue;
  end
  d0 = d-1;
  fprintf("peak at %d\n", d0);
  f = (d0-thresh <= I & I <= d0+thresh);
  CC = bwconncomp(f);
  numPixels = cellfun(@numel,CC.PixelIdxList);
  [biggest,idx] = max(numPixels);
  f = logical(zeros(size(I)(1), size(I)(2)));
  f(CC.PixelIdxList{idx}) = 1;
  objects(:,:,count) = f;
  subplot(4, 2, count+2);
  imshow(f);
  count++;
  M00 = M(0,0,0,0,f);
  M10 = M(1,0,0,0,f);
  M01 = M(0,1,0,0,f);
  x_bar = M10 / M00;
  y_bar = M01 / M00;
  M00_cen = M(0,0,x_bar,y_bar,f);
  M20_cen = M(2,0,x_bar,y_bar,f);
  M02_cen = M(0,2,x_bar,y_bar,f);
  M20_norm = M20_cen / M00_cen^2;
  M02_norm = M02_cen / M00_cen^2;
  V = M20_norm + M02_norm;
  fprintf("V = %6.2f\n", V);
end