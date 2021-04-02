load('compEx1data.mat');
im1 = imread('kronan1.JPG');
im2 = imread('kronan2.JPG');

% F from ex1
F = [-3.390110337114197e-08,-3.720055920403521e-06,0.005772315690151;4.667371855936464e-06,2.893608446817860e-07,-0.026682112427102;-0.007193606616204,0.026295719847587,1];
N1 = nmat(x{1});
N2 = nmat(x{2});

% Epipole 2 and its cross product form
e2 = null(F');
e2x = [0 -e2(3) e2(2); e2(3) 0 -e2(1); -e2(2) e2(1) 0];

% The camera matrices
P1 = [eye(3) zeros(3, 1)];
P2 = [e2x*F e2];

% Code below is for switching camera matrix columns
%{
c31 = P1(:, 3);
c32 = P2(:, 3);
c41 = P1(:, 4);
c42 = P2(:, 4);

P1(:, 3) = c41;
P1(:, 4) = c31;
P2(:, 3) = c32;
P2(:, 4) = c42;
%}

% Normalize the points and cameras
Nx1 = N1 * x{1};
Nx2 = N2 * x{2};
NP1 = N1 * P1;
NP2 = N2 * P2;

% DLT equations for all points
n = length(x{1});
z = zeros(3, 1);
X = zeros(4, n);

for i = 1:n
    M = [NP1 -Nx1(:, i) z; NP2 z -Nx2(:, i)];
    [U, S, V] = svd(M);
    v = V(:, end);
    X(:, i) = v(1:4, 1);
end

% Code below is for switching point rows
%{
r3 = X(3, :);
r4 = X(4, :);
X(3, :) = r4;
X(4, :) = r3;
%}

% Project back with P1
x1 = pflat(P1*X);

% Plot the image points
figure;
imagesc(im1);
hold on;
plot(x{1}(1, :), x{1}(2, :), 'B*', 'MarkerSize',10);
plot(x1(1, :), x1(2, :), 'R.', 'MarkerSize',10);
axis equal;
hold off;

% Plot the 3D points
figure;
plot3(X(1, :), X(2, :), X(3, :), 'B.');