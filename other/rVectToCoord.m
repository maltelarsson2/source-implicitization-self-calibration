function [r] = rVectToCoord(rVect)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if ~isequal(size(rVect), [1 6])
    error("wrong size of rVect")
end

r = [0, 0, 0; rVect(1), 0, 0; rVect(2), rVect(3), 0; rVect(4), rVect(5), rVect(6)]';
end