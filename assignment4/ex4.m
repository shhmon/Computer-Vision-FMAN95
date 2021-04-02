clear;
load('ex2sol.mat');

lambda = 1000;
iter = 10;
figure;

% One iteration per lambda value -> 1000, 100, 10 ...
for i = 1:7
    
    % Set/reset P U u values
    P = {P1, bestP2};
    U = bestX;
    u = inliers;
    
    err = zeros(1, iter+1); 
    
    [err(1), res] = ComputeReprojectionError(P,U,u);
    
    % The 10 iterations
    for j = 1:iter
        [r,J] = LinearizeReprojErr(P,U,u);
        C = J'*J+lambda*speye(size(J,2));
        c = J'*r;
        deltav = -C\c;
        [P,U] = update_solution(deltav,P,U);
        [err(j+1), res] = ComputeReprojectionError(P,U,u);
    end
    
    % Decrease lambda & plot
    lambda = lambda/10;
    plot(0:iter, err);
    hold on;
end

% Take a look at improved solution
%{
figure;
plot3(U(1, :), U(2, :), U(3, :), 'B.');
hold on;
plotcams(P);
axis equal;
%}

rms = sqrt(sum(res.^2)/length(res))
