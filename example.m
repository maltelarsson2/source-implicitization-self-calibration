
%% Choose some data
nbrSenders = 500;
numberOutliers = 50;
noiseLevel = 0.05;
[d2, r_grd, s_grd] = createSynteticDataSet(nbrSenders, numberOutliers, noiseLevel);

%% Set some options for solver
solver_opts = RANSAC_default_options();
solver_opts.iterations = 1000;
solver_opts.ransacBoundary = 0.01;
solver_opts.useSampson = 1; %0 will use trilateration for model evaluation and optimizations with ML-error.
solver_opts.useLocalOptimization = 1;
solver_opts.useRefinement = 1;


%% Find solution
solution = solveToa3D46MexOpt(d2, solver_opts);
%% Plot result
plotResultsToa3D(solution.recievers, solution.senders, solution.inliers, r_grd, s_grd, [], false);


