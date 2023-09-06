function [r_new, M, t] = setCoordinateSystem3DToa46(r)
%setCoordinateSystem3D46 changes coordinates to get r = [0 0 0;x 0 0; y z 0; a b c]'
%   r_new are the new coordinates after applying M*(r-t);
t = r(:, 1);
r = r -repmat(t, [1, size(r,2)]);
[Q, ~] = qr(r(:, 2:end));
M = Q';
r_new  = M*r;
%% mirror to normalize output (get diagonal+1 to be positive)
mirrors = [sign(r_new(1, 2)); sign(r_new(2, 3)); sign(r_new(3, 4))];
r_new = r_new.*mirrors; 
M = M.*mirrors;
end