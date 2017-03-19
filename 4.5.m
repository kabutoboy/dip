wb = waitbar(0, 'Loading images...');
grid = imread("grid.pgm");
distgrid = imread("distgrid.pgm");

scale = 2;

I_src = imresize(distgrid, scale);
I_dst = imresize(grid, scale);

sigma_G = 4;

waitbar(0.1, wb, 'Creating filters...');
kernel_size = 33;
G1 = fspecial("gaussian", kernel_size, sigma_G/8);
G2 = fspecial("gaussian", kernel_size, sigma_G/4);
G3 = fspecial("gaussian", kernel_size, sigma_G/2);
G4 = fspecial("gaussian", kernel_size, sigma_G);
[G4x, G4y] = gradient(G4);
[G4xx, G4xy] = gradient(G4x);

G = cat(3, G1, G2, G3, G4);
F = zeros(kernel_size, kernel_size);

for i = 1:size(G)(3)
  [Gix, Giy] = gradient(G(:,:,i));
  [Gixx, Gixy] = gradient(Gix);
  Gixx45 = cos(45.0/180.0*pi)*Gixx + sin(45.0/180.0*pi)*Gixy;
  Gixx315 = cos(315.0/180.0*pi)*Gixx + sin(315.0/180.0*pi)*Gixy;
  Gix /= norm(Gix, 1);
  Giy /= norm(Giy, 1);
  Gixx /= norm(Gixx, 1);
  Gixx45 /= norm(Gixx45, 1);
  Gixx315 /= norm(Gixx315, 1);
  F(:,:,i,1) = Gix;
  F(:,:,i,2) = -Giy;
  F(:,:,i,3) = Gixx;
  F(:,:,i,4) = Gixx45;
  F(:,:,i,5) = Gixx315;
end

#imshow(0.25*((abs(min(min(F(:,:,4,5)))) + F(:,:,4,5)) / max(max(F(:,:,4,5)))));

waitbar(0.2, wb, 'Creating feature vector fields...');
feature_field_src = zeros(size(I_src)(1), size(I_src)(2));
feature_field_dst = zeros(size(I_dst)(1), size(I_dst)(2));
for i = 1:size(F)(3)
  for j = 1:size(F)(4)
    feature_field_src(:,:,i,j) = imfilter(I_src, F(:,:,i,j), 'conv');
    feature_field_dst(:,:,i,j) = imfilter(I_dst, F(:,:,i,j), 'conv');
  end
end

x_new = 1:1:(size(I_src)(2));
y_new = 1:1:(size(I_dst)(1));
sigma_D = 0.05 * length(I_src);
sigma_S = 10;
alpha_2 = 0.5;

function y = rho(x, s)
  y = log(1 + 0.5 * ((x./s).^2));
end

function ret = eps2(sigma_D, sigma_S, alpha_2)
  epsD2 = 0;
  for i = 1:(size(I_src)(1)/scale)
    for j = 1:(size(I_src)(2)/scale)
      #for k = 1:size(F)(3)
        #for l = 1:size(F)(4)
          #J_src = imfilter(I_src, F(:,:,k,l), 'conv');
          #J_dst = imfilter(I_dst, F(:,:,k,l), 'conv');
          i_ = scale * i;
          j_ = scale * j;
          epsD2 +=...
            sum(sum(...
              rho(...
                feature_field_src(i_, j_, :, :)...
                - feature_field_dst(y_new(i_), x_new(j_), :, :)...
                , sigma_D)
            ));
        #end
      #end
    end 
  end

  x_new_d = gradient(x_new);
  y_new_d = gradient(y_new);
  epsS2 = 0;
  for i = 1:(size(I_src)(1)/scale)
    for j = 1:(size(I_src)(2)/scale)
      i_ = scale * i;
      j_ = scale * j;
      epsS2 += rho(y_new_d_(i_), sigma_S) + rho(x_new_d(j_), sigma_S);
    end 
  end

  ret = epsD2 + alpha_2 * epsS2;
end

waitbar(0.3, wb, 'Initializing...');

walk = [randperm(size(I_src)(2)/scale); randperm(size(I_src)(1)/scale)];
count = 0;
for p = walk
  waitbar(0.3 + count * 0.7 / length(walk), wb, strcat('Doing calculations... (', int2str(count), ')'));
  p_ = scale * p;
  y = p(1);
  x = p(2);
  y_ = p_(1);
  x_ = p_(2);
  lastmin = 0;
  e2 = 0;
  for i = (y_-scale):(y_+scale)
    if i < 1 || i > size(I_src)(1)
      continue;
    end
    for j = (x_-scale):(x_+scale)
      if j < 1 || j > size(I_src)(2)
        continue;
      end
      if abs(i-y_)+abs(j-x_) > scale
        continue;
      end
      x_tmp = x_new(x_);
      y_tmp = y_new(y_);
      x_new(x_) = j;
      y_new(y_) = i;
      #
      #e2 = eps2(sigma_D, sigma_S, alpha_2);
      #
      epsD2 = 0;
      for i = 1:(size(I_src)(1)/scale)
        for j = 1:(size(I_src)(2)/scale)
          #for k = 1:size(F)(3)
            #for l = 1:size(F)(4)
              #J_src = imfilter(I_src, F(:,:,k,l), 'conv');
              #J_dst = imfilter(I_dst, F(:,:,k,l), 'conv');
              i_ = scale * i;
              j_ = scale * j;
              epsD2 +=...
                sum(sum(...
                  rho(...
                    feature_field_src(i_, j_, :, :)...
                    - feature_field_dst(y_new(i_), x_new(j_), :, :)...
                    , sigma_D)
                ));
            #end
          #end
        end 
      end

      x_new_d = gradient(x_new);
      y_new_d = gradient(y_new);
      epsS2 = 0;
      for i = 1:(size(I_src)(1)/scale)
        for j = 1:(size(I_src)(2)/scale)
          i_ = scale * i;
          j_ = scale * j;
          epsS2 += rho(y_new_d(i_), sigma_S) + rho(x_new_d(j_), sigma_S);
        end 
      end

      e2 = epsD2 + alpha_2 * epsS2;
      #
      if (e2 < lastmin)
        lastmin = e2
      else
        x_new(x_) = x_tmp;
        y_new(y_) = y_tmp;
      end
    end
  end
  count++;
end

close(wb);