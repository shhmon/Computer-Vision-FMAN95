load('compEx1.mat');

a = pcalc(x2D);
b = pcalc(x3D);

figure;
plot(a(1, :), a(2, :), '.');
axis equal;

figure;
plot3(b(1 ,:), b(2 ,:), b(3 ,:) , '.');
axis equal;