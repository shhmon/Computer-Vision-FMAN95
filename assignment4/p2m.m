function [M] = p2m(a,b)
% Create M matrix from a and b
[d, n] = size(a);
M = zeros(3*n, 3*d+n);

for i=1:n
    bi = b(:, i);
    ai = a(:, i);
    
    for j=1:d
        M(d*i-d+j, j*d-d+1:j*d) = ai';
    end
    
    M(d*i-d+1:d*i, 3*d+i) = -bi;
end

end

