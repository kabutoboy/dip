function Y = trim(X)
  Y = X;
  Y(Y > 255) = 255;
  Y(Y < 0) = 0;
endfunction

x = 0:1:255;
G1 = imread("grid.pgm");
G2 = imread("distgrid.pgm");
H1 = imhist(G1);
H2 = imhist(G2);
G1 = ordfilt2(G1, 9, [0 0 1 0 0;
                       0 0 1 0 0;
                       1 1 1 1 1;
                       0 0 1 0 0;
                       0 0 1 0 0]);
#G1 = 255 - G1;
G21 = ordfilt2(G2, 9, [0 0 1 0 0;
                       0 0 1 0 0;
                       1 1 1 1 1;
                       0 0 1 0 0;
                       0 0 1 0 0]);
G22 = ordfilt2(G2, 11, [1 0 0 1 1;
                       1 1 0 1 0;
                       0 0 1 0 0;
                       0 1 0 1 1;
                       1 1 0 0 1]);
G2 = G21 - (255 - G22) - (255 - G22);
G2(G2 < 255) = 0;
imwrite(G1, "grid-med.pgm");
imwrite(G2, "distgrid-med.pgm");
imshow(G2);