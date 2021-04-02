function [M] = p2m(x,X)
% Create M matrix from X and x
n = length(X);
M = zeros(3*n, 12+n);

for i=1:n
    Xi = [X(:, i); 1];
    xi = x(:, i);
    
    for j=1:3
        M(3*i-3+j, j*4-3:j*4) = transpose(Xi);
    end
    
    M(3*i-2:3*i, 12+i) = -xi;
end

end

