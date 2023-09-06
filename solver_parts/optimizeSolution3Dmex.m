function [r_new, s] = optimizeSolution3Dmex(r, d2, d, useSampson, s_in)
%optimizeSolution3D Do local optimization from startpoint r.
%   d2 are squared distances. Assumes that the distances are ordered
%   correctly relative r.

if nargin < 3
    useSampson = 1;
end

if useSampson
    r_new = ceresSampsonOpt(rCoordToVect(r), d2);
    s = [];
else
    if nargin < 5
        s_in = computeSenders(d, r);
    end
    [r_new, s] = ceresBundlingFixedCoords(rCoordToVect(r), s_in, d);
end
end