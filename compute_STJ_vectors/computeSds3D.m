function S_ds = computeSds3D(d2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

S_ds = zeros(11, 4*size(d2, 2));

for sender = 1:size(d2,2)
    s0 = d2(1);
    s1 = d2(2);
    s2 = d2(3);
    s3 = d2(4);
    S_ds(:, 4*sender-3:4*sender) = ...
    [0, 0, 0, 0;
    1, 0, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1;
    2*(s0-s1), 2*(s1-s0), 0, 0;
    2*s0-s1-s2, s2-s0, s1-s0, 0;
    2*(s0-s2), 0, 2*(s2-s0), 0;
    2*s0-s1-s3, s3-s0, 0, s1-s0;
    2*s0-s2-s3, 0, s3-s0, s2-s0;
    2*(s0-s3), 0, 0, 2*(s3-s0)];
end
end