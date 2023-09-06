function solution = empty_solution()
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
solution = struct();
solution.inliers = [];
solution.recievers = [];
solution.senders = [];
solution.ransacInfo = ransacInfo();
solution.totalTime = -1;
end