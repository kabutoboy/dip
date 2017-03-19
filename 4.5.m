grid = imread("grid.pgm");
distgrid = imread("distgrid.pgm");
h = imhist(grid);
x = 0:1:255;
#plot(x, h)

sigma_D = 0.05 * length(grid);
sigma_G = 4;

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
  Gixx45 = cos(45/180*pi)*Gixx + sin(45/180*pi)*Gixy;
  Gixx315 = cos(315/180*pi)*Gixx + sin(315/180*pi)*Gixy;
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

imshow(0.25*((abs(min(min(F(:,:,4,5)))) + F(:,:,4,5)) / max(max(F(:,:,4,5)))));

x_new = zeros(size(grid)(2));
y_new = zeros(size(grid)(1));

function y = rho(x, sigma)
  y = log(1 + 0.5 * (x/sigma)**2);
end

I_src = distgrid;
I_dst = grid;
epsilon_D_squared = 0;
for i = 1:size(I_src)(1)
  for j = 1:size(I_src)(2)
    for k = 1:size(F)(3)
      for l = 1:size(F)(4)
        J_src = imfilter(I_src, F(:,:,k,l), 'conv');
        J_dst = imfilter(I_dst, F(:,:,k,l), 'conv');
        epsilon_D_squared += rho_D(J_src(i,j) - J_dst(x_new(i), y_new(j)), sigma);
      end
    end
  end 
end

epsilon_S_squared = 0;
for i = 1:size(I_src)(1)
  for j = 1:size(I_src)(2)
    for k = 1:size(F)(3)
      for l = 1:size(F)(4)
        J_src = imfilter(I_src, F(:,:,k,l), 'conv');
        J_dst = imfilter(I_dst, F(:,:,k,l), 'conv');
        epsilon_D_squared += rho_D(J_src(i,j) - J_dst(x_new(i), y_new(j)), sigma);
      end
    end
  end 
end
