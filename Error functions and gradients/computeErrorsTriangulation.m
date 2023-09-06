function errors = computeErrorsTriangulation(d, r)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if isequal(size(r), [1 6]) || isequal(size(r), [6 1])
    r = [0 0 0; r(1) 0 0; r(2) r(3) 0; r(4) r(5) r(6)]';
end
senders = computeSenders(d, r);
currentD = pdist2(r',senders');
difference  = currentD-d;
errors = sum(difference.^2, 1);
% errors = totalErrorFunction(recievers, senders, d);
end