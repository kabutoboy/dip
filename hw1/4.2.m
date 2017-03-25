x = 0:1:255;
G1 = imread("grid.pgm");
G2 = imread("distgrid.pgm");

i = G2;

mask = [-1 0 1; -1 0 1; -1 0 1]; 
ix = conv2(i, mask, 'same');   
iy = conv2(i, mask', 'same');

g = fspecial('gaussian', 7, 1);
ix2 = conv2(ix.^2, g, 'same');  
iy2 = conv2(iy.^2, g, 'same');
ixiy = conv2(ix.*iy, g,'same');

detA = ix2.*iy2 - ixiy.*ixiy;
traceA = ix2 + iy2;

r = detA - 0.06*traceA.^2; 

minr = min(min(r));
maxr = max(max(r));
r = (r - minr) / (maxr - minr);

threshold = 0.25;
maxima = ordfilt2(r, 25, ones(5));
mask = (r == maxima) & (r > threshold);
maxima = mask.*r;

#maxima = ordfilt2(maxima, 23, [1 1 1 1 1; 1 1 1 1 1; 1 1 0 1 1; 1 1 1 1 1]);

imshow(maxima);