function grad = computeSampsonGradient(d2, r)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
grad = zeros(size(d2, 2), 6);
if isequal(size(r), [1 6]) || isequal(size(r), [6 1])
    r = [0 0 0; r(1) 0 0; r(2) r(3) 0; r(4) r(5) r(6)]';
end

T = computeT3D(r);
for i = 1:size(d2, 2)
    S = computeS3D(d2(:, i));
    J = computeJ3D(d2(:, i), r, T);
    dTdr = computeDTdr(r);
    dJdr = computeDJdr(d2(:, i), r);
    nabla_JJ = 2*J'*dJdr;
    st = S'*T;
    jj = J'*J;
    grad(i,:) = (S'*dTdr*sqrt(jj)-st*nabla_JJ/(2*sqrt(jj)))/jj;
end

end