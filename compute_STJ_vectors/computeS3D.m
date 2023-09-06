function S = computeS3D(d2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% S = zeros(11, size(d2,2));
% for i = 1:size(d2,2)
% 
%     s0 = d2(1, i);
%     s1 = d2(2, i);
%     s2 = d2(3, i);
%     s3 = d2(4, i);
%     S(:, i) = ...
%     [1;
%     s0;
%     s1;
%     s2;
%     s3;
%     (s1-s0)^2;
%     (s0-s1)*(s0-s2);
%     (s0-s2)^2;
%     (s0-s1)*(s0-s3);
%     (s0-s2)*(s0-s3);
%     (s0-s3)^2];
% end

s0 = d2(1);
    s1 = d2(2);
    s2 = d2(3);
    s3 = d2(4);
    S = ...
    [1;
    s0;
    s1;
    s2;
    s3;
    (s1-s0)^2;
    (s0-s1)*(s0-s2);
    (s0-s2)^2;
    (s0-s1)*(s0-s3);
    (s0-s2)*(s0-s3);
    (s0-s3)^2];
end