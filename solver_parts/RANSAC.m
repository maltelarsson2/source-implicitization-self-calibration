function solution = RANSAC(d2, solver_opts, sampsonErrors, sampsonOpt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    sampsonErrors = 1;
end
if nargin < 4
    sampsonOpt = 1;
end


startTime = tic;
nbrRansacIterations = solver_opts.iterations;
ransac_boundary = solver_opts.ransacBoundary;
plotThings = solver_opts.plotThings;
minIterations = solver_opts.minIterations;
dynamicMinIterations = nbrRansacIterations;

maxNbrInliersBeforeOpt = 0;
maxNbrInliersAfterOptimization = 0;
minErrorSumBeforeOpt = size(d2,2)*ransac_boundary;
minErrorSumAfterOptimization = size(d2,2)*ransac_boundary;
d = sqrt(d2);

inliersOverTime = zeros(1, nbrRansacIterations);
valsOverTime = zeros(1, nbrRansacIterations);
timeUsedAfterIterations = zeros(1, nbrRansacIterations);

iters = 1:nbrRansacIterations;
nbrOptimizations = 0;
maxModel = [];


warning('off','MATLAB:nearlySingularMatrix')

for iteration = 1:nbrRansacIterations
    if iteration > minIterations && iteration > dynamicMinIterations 
        break;
    end
    % Choose data for ransac
    senderInd = randperm(size(d2,2), 6);

    % Format data as input - distances
    ransac_data = d2(:, senderInd);
    
% Lös 46-problemet
    [rrc, ~] = toa_46(ransac_data);
    % Evaluate number of points inside boundary
    bestModelBeforeOpt = [];
    inliersBeforeOpt = [];
    for solind = 1:length(rrc)
        rest_pos = setCoordinateSystem3DToa46(rrc{solind});

        if sampsonErrors
            errors = computeErrors3D2(d2(:, :), rest_pos).^2;
        else 
            errors = computeErrorsTriangulation(d(:, :), rest_pos);
        end

        current_inliers = errors<ransac_boundary;
        nbrInliers = sum(current_inliers);
        curSum = sum(min(errors, ransac_boundary*ones(size(errors))));
        if nbrInliers > maxNbrInliersBeforeOpt || curSum < minErrorSumBeforeOpt
            if nbrInliers > maxNbrInliersBeforeOpt
                maxNbrInliersBeforeOpt = nbrInliers;
            end
            if curSum < minErrorSumBeforeOpt
                minErrorSumBeforeOpt = curSum;
            end
            bestModelBeforeOpt = rest_pos;
            inliersBeforeOpt = current_inliers;
            
            if curSum < minErrorSumAfterOptimization

                maxModel = rest_pos;
                minErrorSumAfterOptimization = curSum;
                maxNbrInliersAfterOptimization = nbrInliers;
                modelInliersOpt = current_inliers;
            end

        end

    end

    if ~isempty(bestModelBeforeOpt) && solver_opts.useLocalOptimization
        nbrOptimizations = nbrOptimizations + 1;
        model = optimizeSolution3Dmex(bestModelBeforeOpt, d2(:, inliersBeforeOpt), d(:, inliersBeforeOpt), sampsonOpt);
        
        if sampsonErrors
            errors = computeErrors3D2(d2(:, :), model).^2;
        else 
            errors = computeErrorsTriangulation(d(:, :), model);
        end

        curSum = sum(min(errors, ransac_boundary*ones(size(errors))));
        current_inliers = errors<ransac_boundary;
        if curSum < minErrorSumAfterOptimization
            maxModel = model;
            minErrorSumAfterOptimization = curSum;
            maxNbrInliersAfterOptimization = sum(current_inliers);

            modelInliersOpt = current_inliers;
        end
    end

    if maxNbrInliersAfterOptimization < 4
        dynamicMinIterations = nbrRansacIterations;
    elseif maxNbrInliersAfterOptimization == length(d2)
        dynamicMinIterations = 1;
    else
        dynamicMinIterations = iterationsNeededToFindInlierSet(maxNbrInliersAfterOptimization, length(d2)-maxNbrInliersAfterOptimization, 6, 0.99);
    end


    inliersOverTime(iteration) = maxNbrInliersAfterOptimization;
    valsOverTime(iteration) = minErrorSumAfterOptimization;
    timeUsedAfterIterations(iteration) = toc(startTime);
    
end
ransac_info = ransacInfo();
ransac_info.iterationsUsed = iteration-1;
ransac_info.scoresPerIteration = valsOverTime;
ransac_info.inliersPerIteration = inliersOverTime;
ransac_info.localOptimizationsUsed = nbrOptimizations;
ransac_info.timeUsedAfterIteration = timeUsedAfterIterations;

solution = empty_solution();

ransac_info.time = toc(startTime);
maxModel = setCoordinateSystem3DToa46(maxModel);
ransac_info.recievers = maxModel;
ransac_info.inliers = modelInliersOpt;
solution.ransacInfo = ransac_info;

warning('on','MATLAB:nearlySingularMatrix')
if plotThings
    figure()
    plot(iters, inliersOverTime);
    title("Max inliers per iteration")
    figure()
    plot(iters, valsOverTime);
    title("Error value per iteration")
end
end