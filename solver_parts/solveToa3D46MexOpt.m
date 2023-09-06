function solution = solveToa3D46MexOpt(d2, solver_opts)
%solveToa3D46 d2 - [4 N]-matrix with squared distances, no missing data
%   Recievers will be on the form [0 0 0; x1 0 0; x2 x3 0; x4 x5 x6]';

ransac_boundary = solver_opts.ransacBoundary;
sampsonErrors = solver_opts.useSampson;
sampsonOpt = solver_opts.useSampson;

assert(size(d2, 1) == 4, 'Wrong number rows');
assert(size(d2, 2) >= 6, 'Too few columns');
assert(sum(sum(isnan(d2))) == 0, 'Has missing data');


% Ss = computeS3D(data);
% S_ds = computeSds3D(data);
%% RANSAC
startTime = tic();
solution = RANSAC(d2, solver_opts, sampsonErrors, sampsonOpt);


maxModel = solution.ransacInfo.recievers;
d = sqrt(d2);
%% Optimize r over all valid s
model = setCoordinateSystem3DToa46(maxModel);
if solver_opts.useRefinement
    [model, s] = optimizeSolution3Dmex(model, d2(:,solution.ransacInfo.inliers), d(:,solution.ransacInfo.inliers), sampsonOpt);
end

%% Compute senders
recievers = model;
if sampsonErrors
    errors = computeErrors3D2(d2(:, :), model).^2;
else 
    errors = computeErrorsTriangulation(d(:, :), model);
end
inliers = errors<ransac_boundary;
senders = zeros(3, size(d2,2));
for i = 1:size(d2, 2)
    senders(:,i) = solver_opttrilat(recievers, sqrt(d2(:, i)));
end
if ~sampsonOpt && solver_opts.useRefinement
    senders(:, solution.ransacInfo.inliers) = s;
end
solution.totalTime = toc(startTime);

solution.recievers = recievers;
solution.senders = senders;
solution.inliers = inliers;
end