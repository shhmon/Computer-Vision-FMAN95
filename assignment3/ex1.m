load('compEx1data.mat');
im1 = imread('kronan1.JPG');
im2 = imread('kronan2.JPG');

% Normalization matrices
N1 = nmat(x{1});
N2 = nmat(x{2});

% Normalize the points
N1x = N1 * x{1};
N2x = N2 * x{2};

% Buld the M matrix
n = length(x{1});
M = zeros(n, 9);

for i = 1:n
    xx = N2x(:,i)*N1x(:,i)';
    M(i,:) = xx(:)';
end

% Solve with SVD
[U, S, V] = svd(M);
v = V(:, end);
Fn = reshape(v,[3 3]);
% Minimize determinant
[U, S, V] = svd(Fn);
S(3,3) = 0;
Fn = U*S*V';
plot(diag(N2x'*Fn*N1x));
% Un-normalize
F = N2'*Fn*N1;
F = F./F(3, 3);

% Verify solution
det(F)

% Epipolar lines
l = F*x{1};
l = l./sqrt(repmat(l(1,:).^2 + l(2,:).^2,[3 1]));

% Some random points
r = randi([0, n],1,20);
xplot = zeros(3, 20);
lplot = zeros(3, 20);

for i = 1:20
    xplot(:, i) = x{2}(:, r(1, i));
    lplot(:, i) = l(:, r(1, i));
end

% Plot
figure;
imagesc(im2);
hold on;
plot(xplot(1, :), xplot(2, :), 'R.', 'MarkerSize',10);
rital(lplot);
axis equal;
hold off;

figure;
hist(abs(sum(l.*x{2})),100);