function [rVect] = rCoordToVect(r)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if ~isequal(size(r), [3 4])
    error("wrong size of r")
end
rVect = [r(4), r(7), r(8), r(10), r(11), r(12)];
end