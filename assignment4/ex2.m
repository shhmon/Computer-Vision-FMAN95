clear;
load('compEx2data.mat');

n = length(x{1});

% Add a one to the coordinates
x{1}(end+1, :) = 1;
x{2}(end+1, :) = 1;

% Normalized points
xn = {K\x{1}, K\x{2}};

besti = [];
thresh = 5;
pts = 5;

% --------- Find E ----------
for i = 1:20
    % Random point indeces
    r = randi([1, n],1,pts);
    
    % Get the E matrices
    Es = fivepoint_solver(xn{1}(:, r), xn{2}(:, r));
    
    for e = 1:length(Es)
        inlier_i = [];
        
        F = K^(-1)'*Es{e}*K^(-1);
        
        for j = 1:n
            l = F*x{1}(:, j);
            l = l./sqrt(repmat(l(1,:).^2 + l(2,:).^2,[3 1]));
            dist = abs(sum(l.*x{2}(:, j)));
            
            if dist < thresh
                inlier_i = [inlier_i j];
            end
        end
        
        if length(inlier_i) > length(besti)
            bestE = Es{e};
            besti = inlier_i;
        end
    end
end

% Extract unnormalized inliers
in = length(besti);
inliers = {x{1}(:, besti), x{2}(:, besti)};

% SVD for best E matrix
bestE = bestE/bestE(3,3);
[U, S, V] = svd(bestE);

% Standard camera 1 & W
P1 = K*[eye(3) zeros(3, 1)];
W = [0 -1 0; 1 0 0; 0 0 1];

% The camera 2 matrices
P2 = {K*[U*W*V' U(:, 3)], ...
     K*[U*W*V' -U(:, 3)], ...
     K*[U*W'*V' U(:, 3)], ...
     K*[U*W'*V' -U(:, 3)]};

% --------- Triangulate ----------
z = zeros(3, 1);
pifMax = 0;

for p = 1:4
    X = zeros(4, in);
    pif = 0;
    
    for i = 1:in
        M = [P1 -inliers{1}(:, i) z; P2{p} z -inliers{2}(:, i)];
        [U, S, V] = svd(M);
        v = V(:, end);
        X(:, i) = [pflat(v(1:4, 1)); 1];
        
        % Check if point in front of cameras
        if depth(P2{p}, X(:, i)) > 0 && depth(P1, X(:, i)) > 0
            pif = pif + 1;
        end
    end
    
    if pif > pifMax
        bestX = X;
        bestP2 = P2{p};
        pifMax = pif;
    end
end

% Plot the best solution
figure;
plot3(bestX(1, :), bestX(2, :), bestX(3, :), 'B.');
hold on;
plotcams({P1, bestP2});
axis equal;

% Historgram  of reprojection error
[err, res] = ComputeReprojectionError({P1, bestP2}, bestX, inliers);
figure;
hist(res, 100);

rms = sqrt(sum(res.^2)/length(res))

%save('ex2sol.mat', 'P1', 'bestP2', 'bestX', 'inliers');

