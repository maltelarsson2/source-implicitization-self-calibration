function errors = computeErrors3D2(d2,r, Ss)
% Compute the quadrisonal error. The answer is unsquared.
% errors = zeros(1, size(d2, 2));
if isequal(size(r), [1 6]) || isequal(size(r), [6 1])
    r = [0 0 0; r(1) 0 0; r(2) r(3) 0; r(4) r(5) r(6)]';
end

T = computeT3D(r);
errors = zeros(1, size(d2, 2));

if nargin < 3
    Ss = zeros(11, size(d2,2));
    for sender = 1:size(d2,2)
        Ss(:, sender) = computeS3D(d2(:, sender));
    end
end
cs = Ss'*T;

for sender = 1:size(d2,2)
    J = computeJ3D(d2(:, sender), r, T);
    errors(sender) = cs(sender)/norm(J);

end

end