function J = computeJ3D(d2, r, T, S_ds)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    T = computeT3D(r);
end
if nargin < 4
    S_ds = zeros(11, 4*size(d2, 2)); 
    for sender = 1:size(d2,2)
        S_ds(:, 4*sender-3:4*sender) = computeSds3D(d2(:, sender));
    end
end

J = (S_ds'*T);
J = reshape(J, 4, size(d2,2));
J = 2*diag(sqrt(d2))*J;

end