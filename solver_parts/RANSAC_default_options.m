function opts = RANSAC_default_options()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
opts = struct();
opts.iterations = 1000;
opts.ransacBoundary = 0.005^2;
opts.plotThings = false;

opts.minIterations = -1;

%1 - sampsonOpt and sampsonErrors, 0 - bundleOpt and trilat errors.
opts.useSampson = 1;
opts.useLocalOptimization = 1;
opts.useRefinement = 1;

end