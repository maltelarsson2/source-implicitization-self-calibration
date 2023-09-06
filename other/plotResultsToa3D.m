function plotResultsToa3D(r, senders, inliers, r_grd, s_grd, s_grd_missing, includeLegend)
%plotResultsToa3D Plot results
%   Detailed explanation goes here

assert(length(inliers) == size(senders, 2), "wrong length of inlier vector");
% [r, M, t] = setCoordinateSystem3DToa46(r);
% senders = M*(senders-t);
% 
% [r_grd, M, t] = setCoordinateSystem3DToa46(r_grd);
% s_grd = M*(s_grd-t);
inliers = inliers==1;
[~,r, transform] = procrustes(r_grd', r', 'scaling',false);
r = r';
senders = (transform.b*senders'*transform.T+repmat(transform.c(1,:), [size(senders', 1), 1]))';

if nargin < 6 || isempty(s_grd_missing)
    s_grd_missing = [];
else
    s_grd_missing = M*(s_grd_missing-t);
end


if nargin < 7
    includeLegend = false;
end


inlierSenders = senders(:, inliers);
outlierSenders = senders(:, ~inliers);

figure()
hold on
plot3(r(1,:), r(2,:), r(3,:), 'xr');
plot3(inlierSenders(1,:), inlierSenders(2,:), inlierSenders(3,:), 'b.');
if length(outlierSenders) > 500
    plot3(outlierSenders(1,:), outlierSenders(2,:), outlierSenders(3,:), 'r.', 'MarkerSize', 1);
else
    plot3(outlierSenders(1,:), outlierSenders(2,:), outlierSenders(3,:), 'r.');
end

plot3(r_grd(1,:), r_grd(2,:), r_grd(3,:), 'bo');
plot3(s_grd(1,:), s_grd(2,:), s_grd(3,:), 'go');
if ~isempty(s_grd_missing)
    plot3(s_grd_missing(1,:), s_grd_missing(2,:), s_grd_missing(3,:), 'g.', 'MarkerSize', 1);
end

grid on
% axis equal
hold off
end