function N = nmat(x)
    % Compute normalization matrix from points
    meani = mean(x(1:2,:),2);
    stdi = std(x(1:2,:),0,2);
    N = [(1/stdi(1)) 0 -((1/stdi(1))*meani(1));
           0 (1/stdi(2)) -((1/stdi(2))*meani(2));
           0 0 1];

end

