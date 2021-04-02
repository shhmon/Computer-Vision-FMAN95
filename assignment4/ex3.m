clear;
load('ex2sol.mat');

gammak = 1;
iter = 10;

P = {P1, bestP2};
U = bestX;
u = inliers;

err = zeros(1, iter+1); 

[err(1), res] = ComputeReprojectionError(P,U,u);

for j = 1:iter
    [r,J] = LinearizeReprojErr(P,U,u);    
    
    [newP,newU] = update_solution(-gammak*J'*r,P,U);
    [err(j+1), res] = ComputeReprojectionError(newP,newU,u);
    
    while err(j+1) > err(j)
        gammak = gammak/10;
        [newP,newU] = update_solution(-gammak*J'*r,P,U);
        [err(j+1), res] = ComputeReprojectionError(newP,newU,u);
    end
    
    P = newP;
    U = newU;
end

figure;
plot(0:iter, err);

rms = sqrt(sum(res.^2)/length(res))