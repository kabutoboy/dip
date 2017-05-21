blackcirc = im2bw(mat2gray(imread('circle.png')(:,:,1)), 0.8);
train = im2bw(mat2gray(imread('Choice_train01.jpg')), 0.8);
test1 = im2bw(mat2gray(imread('Choice_test01.jpg')), 0.8);
test2 = im2bw(mat2gray(imread('Choice_Rtest01.jpg')), 0.8);
xcross = im2bw(mat2gray(imread('xcross.png')(:,:,1)), 0.8);

function [C] = myxcorr2(A, B)
  s1 = max(size(A)(1), size(B)(1));
  s2 = max(size(A)(2), size(B)(2));
  C = real(ifft2(
      conj(fft2(imcomplement(A), s1, s2))
      .*
      fft2(imcomplement(B), s1, s2)));
  C = flipud(C);
end

function [x1,y1,x2,y2] = getpivot(C, blackcirc)
  [ssr,snd] = max(C(:));
  [y1,x1] = ind2sub(size(C),snd);
  p1 = padarray(blackcirc,[size(C)(1)-size(blackcirc)(1),size(C)(2)-size(blackcirc)(2)],255,'post');
  p1 = circshift(p1, [y1-floor(size(blackcirc)(1)/2),x1-floor(size(blackcirc)(2)/2)]);
  C_ = imsubtract(mat2gray(C), imcomplement(mat2gray(p1)));
  [ssr,snd] = max(C_(:));
  [y2,x2] = ind2sub(size(C_),snd);
  if x1 > x2
    tmp1 = x1;
    tmp2 = y1;
    x1 = x2;
    y1 = y2;
    x2 = tmp1;
    y2 = tmp2;
  end
  #y1 = size(C)(1) - y1;
  #y2 = size(C)(1) - y2;
end

function [dis] = getdis(x1,y1,x2,y2)
  dis = sqrt((x1-x2)^2+(y1-y2)^2);
end

function [ang] = getang(x1,y1,x2,y2)
  ang = atan2(y2-y1,x2-x1) * 180 / pi;
end

function [dis,ang,x1,y1,x2,y2] = getpivot2(A, B)
  C = myxcorr2(A, B);
  [x1,y1,x2,y2] = getpivot(C, B);
  dis = getdis(x1,y1,x2,y2);
  ang = getang(x1,y1,x2,y2);
end

function [A, B] = padeq(A, B)
  d1 = size(A)(1) - size(B)(1);
  d2 = size(A)(2) - size(B)(2);
  if d1 < 0
    A = padarray(A,[-d1,0],255,'post');
  else
    B = padarray(B,[d1,0],255,'post');
  end
  if d2 < 0
    A = padarray(A,[0,-d2],255,'post');
  else
    B = padarray(B,[0,d2],255,'post');
  end
end

function [E,F] = test(A, B, C, xcross)
  [dis0,ang0,x01,y01,x02,y02] = getpivot2(A, C);
  [dis2,ang2,x21,y21,x22,y22] = getpivot2(B, C);

  #imshow(mat2gray(C1));
  #subplot(1,5,1);
  #imshow(A);
  #subplot(1,5,2);
  #imshow(B);
  [test2size1 test2size2] = size(B);
  test2 = imrotate(B,ang0-ang2,'bilinear','crop');
  test2 = imresize(B,dis0/dis2);
  #[dis2,ang2,x21,y21,x22,y22] = getpivot2(test2, blackcirc);
  ang2_ = (ang0-ang2) * pi / 180;
  x21_ = x21 - test2size2/2;
  y21_ = y21 - test2size1/2;
  x21_ = x21_ * cos(ang2_) - y21_ * sin(ang2_);
  y21_ = x21_ * sin(ang2_) + y21_ * cos(ang2_);
  x21_ = x21_ + test2size2/2;
  y21_ = y21_ + test2size1/2;
  x21_ *= dis0/dis2;
  y21_ *= dis0/dis2;
  x21_ += size(C)(2)/2;
  #y21_ -= size(blackcirc)(1)/2;
  x21_ = floor(x21_);
  y21_ = floor(y21_);
  test2 = imtranslate(B,x21_-x01,y21_-y01,'crop');
  #udata = [1 size(test2)(1)];
  #vdata = [1 size(test2)(2)];
  #test2 = (imtransform(test2, maketform('affine', [1 0 5; 0 1 0; 0 0 1])));
  [A, B] = padeq(A, B);
  #train = uint8(train);
  #test2 = uint8(test2);
  se = strel('disk', 2, 0);
  A = imdilate(imcomplement(A), se);
  #subplot(1,5,3);
  imshow(A);
  #subplot(1,5,4);
  E = imsubtract(imcomplement(B), (A));
  imshow(imcomplement(E));
  #subplot(1,5,5);
  #F = medfilt2(E, imcomplement(xcross));
  F = myxcorr2(E, imcomplement(xcross));
  #F = xcorr2(E, imcomplement(xcross));
  #imshow(im2bw(mat2gray(F),0.35));
end

[E,F] = test(train, test2, blackcirc, xcross);
