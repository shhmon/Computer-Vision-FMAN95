% vl_setup
clear

A = imread('a.jpg');
B = imread('b.jpg');

% Compute sift features
[fA dA] = vl_sift( single(rgb2gray(A)) );
[fB dB] = vl_sift( single(rgb2gray(B)) );

% Match the descriptors
matches = vl_ubcmatch(dA,dB);

% Extract matching points
xA = fA(1:2,matches(1,:));
xA(end+1, :) = 1;
xB = fB(1:2,matches(2,:));
xB(end+1, :) = 1;

n = length(xA);

besti = 0;
thresh = 5;
pts = 4;

for i = 1:20
    % Random point indeces
    r = randi([1, length(xA)],1,pts);
    
    % Pick the points
    xAr = xA(:, r);
    xBr = xB(:, r);
    
    % Get the M matrix (using func from assignment2)
    M = p2m(xAr,xBr);
    
    % Solve and extract H matrix
    [U, S, V] = svd(M);
    v = V(:, end);
    H = [v(1:3, :)'; v(4:6, :)'; v(7:9, :)'];
    
    inliers = [];
    
    for j = 1:n
        pt1 = H*xA(:, j);
        pt1 = pt1/pt1(3);
        pt2 = xB(:, j);
        
        dist = sqrt(sum(pt1 - pt2)^2);
        
        if dist < thresh
            inliers = [inliers j];
        end
    end
    
    if length(inliers) > besti
        bestH = H;
        besti = length(inliers);
    end
end




Htform = projective2d(bestH');
%Creates a transfomation that matlab can use for images. %Note: MATLAB uses transposed transformations.
Rout = imref2d(size(A),[-200 800],[-400 600]);
%Sets the size and output bounds of the new image.
[Atransf] = imwarp(A,Htform,'OutputView',Rout);
%Transforms the image
Idtform = projective2d(eye(3));
[Btransf] = imwarp(B,Idtform,'OutputView',Rout); %Creates a larger version of the second image
AB = Btransf;
AB(Btransf < Atransf) = Atransf(Btransf < Atransf);
%Writes both images in the new image. %(A somewhat hacky solution is needed %since pixels outside the valid image area are not allways zero...)
imagesc(Rout.XWorldLimits ,Rout.YWorldLimits ,AB);
