function ransac_info = ransacInfo()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
ransac_info = struct();
ransac_info.scoresPerIteration = [];
ransac_info.inliersPerIteration = [];
ransac_info.localOptimizationsUsed = -1;
ransac_info.iterationsUsed = -1;
ransac_info.time = -1;
ransac_info.inliers = [];
ransac_info.recievers = [];
ransac_info.senders = [];
ransac_info.timeUsedAfterIteration = [];
ransac_info.optRPerIteration = cell(0);
end