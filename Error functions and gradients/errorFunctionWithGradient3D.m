function [fun,grad] = errorFunctionWithGradient3D(x,d2)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
r = [0, 0, 0; x(1), 0, 0; x(2), x(3), 0; x(4), x(5), x(6)]';
errors = computeErrors3D2(d2, x)/sqrt(size(d2,2));
fun = errors*errors';
grad = computeSampsonGradient(d2, r)'/sqrt(size(d2,2))*errors';
end