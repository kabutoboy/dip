x = 0:1:255;
G1 = imread("grid.pgm");
G2 = imread("distgrid.pgm");

C = normxcorr2(G1, G2);
dilatedC = imdilate(max(max(C)) - C, strel('disk', 3, 0));
#figure, surf(c), shading flat

subplot(1,3,1)
imagesc(G1)
axis image off
colormap gray
title('original grid')

subplot(1,3,2)
imagesc(G2)
axis image off
colormap gray
title('distorted grid')

subplot(1,3,3)
imagesc(C)
axis image off
colormap gray
title('cross-correlation')