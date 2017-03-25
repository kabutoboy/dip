R = int16(imread("SanFranPeak_red.pgm"));
G = int16(imread("SanFranPeak_green.pgm"));
B = int16(imread("SanFranPeak_blue.pgm"));
I1 = uint8(2 * G - R - B);
I2 = uint8(R - B);
I3 = uint8((R + G + B) ./ 3);
imwrite(I1, "SanFramPeak_1.pgm");
imwrite(I2, "SanFramPeak_2.pgm");
imwrite(I3, "SanFramPeak_3.pgm");