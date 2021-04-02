% Run ex3 before this file for U, V, n and normalised points
load('compEx1data.mat');

P1 = [eye(3) zeros(3, 1)];
W = [0 -1 0; 1 0 0; 0 0 1]

% The camera 2 matrices
P2 = {[U*W*V' U(:, 3)], ...
     [U*W*V' -U(:, 3)], ...
     [U*W'*V' U(:, 3)], ...
     [U*W'*V' -U(:, 3)]};

% Triangulate;
z = zeros(3, 1);
X = {zeros(4, n), zeros(4, n), zeros(4, n), zeros(4, n)}; 
pifMax = 0;
indMax = 0;

for p = 1:4
    for i = 1:n
        M = [P1 -x1(:, i) z; P2{p} z -x2(:, i)];
        [U, S, V] = svd(M);
        v = V(:, end);
        X{p}(:, i) = v(1:4, 1);
    end
    
    X{p} = pflat(X{p});
    X{p}(4, :) = 1;
    
    % Determine best solution
    x1p = P1*X{p};
    x2p = P2{p}*X{p};
    pif = sum(x1p(3, :) > 0) + sum(x2p(3, :) > 0);
    
    if pif > pifMax
        pifMax = pif;
        indMax = p;
    end
end

% Plot the best solution
figure;
plot3(X{indMax}(1, :), X{indMax}(2, :), X{indMax}(3, :), 'B.');
hold on;
plotcams({P1, P2{indMax}});
axis equal;
hold off;

% Plot the image, points and projections
xp = pflat(K*P2{indMax}*X{indMax});
figure;
imagesc(im2);
hold on;
plot(x{2}(1, :), x{2}(2, :), 'B*', 'MarkerSize',10);
plot(xp(1, :), xp(2, :), 'R.', 'MarkerSize',10);
axis equal;
hold off;