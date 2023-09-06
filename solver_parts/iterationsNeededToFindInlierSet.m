function iters = iterationsNeededToFindInlierSet(nbrInliers, nbrOutliers, minimalDataSet, desiredProb)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    minimalDataSet = 6;
end

if nargin < 4
    desiredProb = 0.99;
end

prob = 1;
if nargin < 4
    minimalDataSet = 6;
end
for i = 0:minimalDataSet-1
    prob = prob * (nbrInliers-i)/(nbrInliers + nbrOutliers-i);
end

iters = log(1-desiredProb)/log(1-prob);

% eps = nbrOutliers/(nbrOutliers + nbrInliers);
% iters2 = log(1-desiredProb)/log(1-(1-eps)^minimalDataSet);
% fprintf("%g - %g", iters, iters2)
end