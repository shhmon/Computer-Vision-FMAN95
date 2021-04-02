function [depth] = depth(P,X)
%Returns the depth of point X in camera P
A = P(:, 1:3);
a = P(:, 4);
A3 = A(3, :);
a3 = a(3, 1);
s = (sign(det(A))/norm(A3));
depth = s*[A3 a3]*X;
end

