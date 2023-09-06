function val = errorFunction3D2(x, d2)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
r = zeros(3, 4);
r(1, 2) = x(1);
r(1, 3) = x(2);
r(2, 3) = x(3);
r(1, 4) = x(4);
r(2, 4) = x(5);
r(3, 4) = x(6);
errors = computeErrors3D2(d2, r);
val = errors*errors';
end