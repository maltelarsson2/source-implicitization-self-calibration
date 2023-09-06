
rVals = randi(100, [1 6])-50;
sVals = 10*rand([1 4])-5;
sVals2 = (sVals.^2)';
r = [0 0 0; rVals(1) 0 0; rVals(2) rVals(3) 0; rVals(4) rVals(5) rVals(6)]';
s_pos = randi(100, [3 1])-50;
d = pdist2(r', s_pos');
sVals2 = d.^2;
rVals = rVals+[1, -0.5, 0.2, -0.9, 0.02, 0];
r = [0 0 0; rVals(1) 0 0; rVals(2) rVals(3) 0; rVals(4) rVals(5) rVals(6)]';


T2 = computeT3D(r);
S2 = computeS3D(sVals2);
sds2 = computeSds3D(sVals2);
J2 = computeJ3D2(sVals2, r, T2, sds2);
error2 = computeErrors3D2(sVals2, r);
dJdr2 = 2*diag(sqrt(sVals2))*computeDJdr(sVals2, r);
dTdr2 = computeDTdr(r);
grad2 = computeSampsonGradient2(sVals2, r);
[T1, S1, sds1, J1, error1, dJdr1, dTdr1, grad1] = testSAndT2(rVals, sVals2);

T_diff = (T1-T2)';
S_diff = (S1-S2)';
sds_diff = sds1-sds2;
J_diff = (J1-J2)';
error_diff = error1-error2
dJdr_diff = dJdr1-dJdr2;
dTdr_diff = dTdr1-dTdr2;
grad_diff = grad1-grad2'
sum([sum(abs(T_diff)), sum(abs(S_diff)), sum(sum(abs(sds_diff))), sum(abs(J_diff)), abs(error_diff)]);
%%
r = [0 0 0; 1 0 0; 2 3 0; 1 2 3]';
% s = [1 0 1; 0 1 0; 0 1 1; 2 1 0; 2 2 1; 1 3 -1; 3 -1 2]';
nbrSenders = 100;
s = 10*rand([3 nbrSenders])-2;
d = pdist2(r', s');
d2 = d.^2;
r_test = [0 0 0; 1.1 0 0; 2 3 0; 1 2 3]';
r_in = [r_test(1,2), r_test(1,3), r_test(2,3), r_test(1,4), r_test(2,4), r_test(3,4)];
%% 
tic
% [r_new, rVectPerIter, timePerIter] = ceresSampsonOptSaveValues(r_in, d2);
r_new2 = ceresSampsonOptPrints(r_in, d2);
toc
%%
s_in = computeSenders(d, r_test);
[r_new2, s2] = ceresBundlingFixedCoords(r_in, s_in, d);
[r_new3, s3, costPerIteration, timePerIteration] = ceresBundlingFixedCoordsSaveValues(r_in, s_in, d);


%%
s_in = computeSenders(d, r_test);
tic
[r_new2, s2] = ceresBundlingPrints2(r_test, s_in, d);
% [r_new3, s3, costPerIteration, timePerIteration] = ceresBundlingSaveValues(r_test, s_in, d);

toc
[r_new2, M, t] = setCoordinateSystem3DToa46(r_new2);
s2 = M*(s2-t);
%%
opts = RANSAC_default_options();
tic
r_new_matlab = optimizeSolution3D(r_test, d2, opts)
toc
%%
r_test2 = [0 0 0; 1 0 0; 2 2 0; 2 2 2]';
d_test = pdist2(r_test2', s');
d2_test = d_test.^2
