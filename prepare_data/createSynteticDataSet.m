function [d2, r_grd, s_grd] = createSynteticDataSet(nbrSenders, numberOutliers, noiseLevel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

r_grd = 4*rand([3 4])-2*ones([3, 4]);

s_grd = 4*rand([3 nbrSenders])-2*ones([3, nbrSenders]);

d = pdist2(r_grd',s_grd');
d = d + normrnd(0, noiseLevel, size(d));
outliers = 7*rand(4, numberOutliers);
d = [d outliers];
d2 = d.^2;
end