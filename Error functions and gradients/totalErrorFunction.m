function errors = totalErrorFunction(r, s, d)
%UNTITLED Function for optimizing over all variables.
%   r should be 3x4, s should be 3xn, d should be distances 4xn

currentD = pdist2(r',s');
difference  = currentD-d;
errors = difference(:);


end