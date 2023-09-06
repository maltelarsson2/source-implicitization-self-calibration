function senders = computeSenders(d, recievers)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
senders = zeros(3, size(d,2));
for i = 1:size(d, 2)
    senders(:,i) = solver_opttrilat(recievers, d(:, i));
end
end