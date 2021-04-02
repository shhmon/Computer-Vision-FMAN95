function [Y] = pcalc(X)
    %dim = size(X, 1);
    %len = length(X);
    [m, n] = size(X);
    Y = [];
    
    for i = 1:n
        Y = [Y pflat(X(:, i))];
    end
    
    % Remove last row
    Y = Y(1:m-1, :);
end