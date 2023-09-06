function error = optimizeAllVariables(x,d)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
r = x(1:12);
s = x(13:end);
r = reshape(r, [3 4]);
s = reshape(s, [3, length(s)/3]);
error = sum(totalErrorFunction(r, s, d));
end