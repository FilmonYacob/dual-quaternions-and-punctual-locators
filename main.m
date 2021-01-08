% Copyright(c) 2020, Filmon Yacob.
% Distributed under the MIT License  

% Validates the DQ-based appraoch against stream of variation models %
clear; clc; close all;
rng('default')
include_namespace_dq %(This library can be removed to increase execution speed).
tic 
% Nominal fixture info
nominalPs = [30, 10, 0; ...
    70, 50, 0; ...
    30, 90, 0; ...
    30, 0, 35; ...
    70, 0, 35; ...
    0, 50, 20];

% cutting temperature at 30C
ts3 = -0.0052 * 30 + 0.0816;

% tool wear Primary and secondary cutting tool-edge
tw3Prim = 0.1248 * 0.3;
tw3Sec  = 0.1349 * 0.3;

% Locator errors, all experiments
deltas = [-0.008, 0.00, 0.012, -0.018, -0.004, 0.000, 0, 0, 0; ...
    -0.041, 0.00, 0.096, -0.018, -0.004, 0.000, 0, 0, 0; ...
    -0.041, 0.00, 0.096, -0.018, -0.004, 0.000, ts3, tw3Prim, tw3Sec];
deltas(:, 1:3) = -deltas(:, 1:3); % Referece coordinate system direction is upside down 

% All experiments
%%
tpchecks = [];
testPntsAllExper = [];
% for e = 1:size(deltas, 1)

for e = 1:3
    
    %disp(strcat('Experiment ', num2str(e)))
    [fixDatums, Ps] = getAllFixturePlanes(nominalPs, deltas(e, 1:6));
    
    fixDatums = [fixDatums.PrimaryF.vec8, ...
        fixDatums.SecondaryF.vec8, ...
        fixDatums.TertiaryF.vec8];
 
    % workpiece info
    %%
    v8WorkPiece = getWorkpiece();
    
    % Run operations
    %%
    v8WorkPiece = operationStn1(v8WorkPiece, fixDatums, Ps, deltas(e, :));
    % vSides = getSidesFromPlaneIntersections(v8WorkPiece);
    % visualizeWorkpieceFixture(fixDatums, vSides, Ps);
    % title('Station 1')
    
    %
    %%
    v8WorkPiece = operationStn2(v8WorkPiece, fixDatums, Ps, deltas(e, :));
    % figure
    % vSides = getSidesFromPlaneIntersections(v8WorkPiece);
    % visualizeWorkpieceFixture(fixDatums, vSides, Ps);
    % title('Station 2')
    
    %
    %%
    v8WorkPiece = operationStn3(v8WorkPiece, fixDatums, Ps, deltas(e, :));
    % figure
    % vSides = getSidesFromPlaneIntersections(v8WorkPiece);
    % visualizeWorkpieceFixture(fixDatums, vSides, Ps);
    % title('Station 3')
    
    % final check
    %%
    tol = 10^-4;
    err = getProjectedTestPointsPlucker2(fixDatums(:, 1), Ps(1:3, :), fixDatums(2:4, 1)) - ...
        getProjectedTestPointsPlucker2(v8WorkPiece(:, 2), Ps(1:3, :), fixDatums(2:4, 1));
    % Move to insection station
    %%
    tp = getTestPoints();
    v8WorkPiece = moveToInspectionStation(v8WorkPiece,1,5);

    tpchecks = [tpchecks, [getProjectedTestPointsPlucker2(v8WorkPiece(:, 3), tp(3, :), [0 0 1]); ...
        getProjectedTestPointsPlucker2(v8WorkPiece(:, 4), tp(4, :), [0 0 1]); ...
        getProjectedTestPointsPlucker2(v8WorkPiece(:, 9), tp(9, :),[0 1 0])]];
    testPnts = getProjectedTestPointsPlucker2(v8WorkPiece, tp, []);
    
    testPntsAllExper = [testPntsAllExper, testPnts];
    
    
end
 
% Predicted KPCs
%%
KPC1 = abs(testPntsAllExper(1, [3, 6, 9])-testPntsAllExper(3, [3, 6, 9]))';
KPC2 = abs(testPntsAllExper(1, [3, 6, 9])-testPntsAllExper(4, [3, 6, 9]))';
KPC3 = abs(testPntsAllExper(5, [2, 5, 8])-testPntsAllExper(9, [2, 5, 8]))';
KPCs = [KPC1, KPC2, KPC3]
toc
% Experimetnal data
%%
ActualMeasurement = [44.991, 40.048, 85.014; ...
    44.984, 40.253, 84.972; ...
    44.975, 40.196, 85.015];
%
SOVPrediction = [44.999, 40.032, 85.008; ...
    45.003, 40.229, 84.986; ...
    45.003, 40.229, 84.986];
%
AveragePredictionErrDQ = mean(abs([[KPC1, KPC2, KPC3] - ActualMeasurement]), 2)
AveragePredictionErrDQFromSOV = mean(abs([[KPC1, KPC2, KPC3] - SOVPrediction]), 2);
AveragePredictionErrSOV = mean(abs([SOVPrediction - ActualMeasurement]), 2)
%  
extendedSoV = [0.01, 0.019, 0.01];
y = [AveragePredictionErrSOV'; ...
    extendedSoV; ...
    AveragePredictionErrDQ']';
%
%%
figure
bar(abs(y))
fs = 14;
legend('SoV', 'Extended SoV', 'DQ-based','FontSize',fs)
ylabel('Average prediciton error','FontSize',fs)
xlabel('Experiment number','FontSize',fs)
set(gca,'FontSize',fs)

%
%%
function v8WorkPiece = operationStn1(v8WorkPiece, fixDatums, Ps, deltas)
%disp('Running Station 1 ...')

include_namespace_dq

% Assemble to fixture
stn = 1;
v8WorkPiece = assemblePrimSecTert(v8WorkPiece, fixDatums, Ps, stn);

% cutting plane
dTemp = deltas(:, 7);
dTwPrim = deltas(:, 8);

s1CuttingPlane = vec8(k_+E_*45);
thetas = [0, 0, 0, 0];
Ds = [0, dTemp, 0, dTwPrim];
axis = [0, 0, 1; 0, 0, 1; 0, 0, 1; 0, 0, 1];
axisPoint = [0, 0, 0; 0, 0, 0; 0, 0, 0; 0, 0, 0];
planeWithMachErr = getMachiningError(s1CuttingPlane, thetas, Ds, axis, axisPoint);
v8WorkPiece(:, 3) = planeWithMachErr; % replace the machined surf
end

%
%%
function v8WorkPiece = operationStn2(v8WorkPiece, fixDatums, Ps, deltas)
%disp('Running Station 2 ...')

include_namespace_dq

% Rotate and place
R = rot2dquat(180, [1, 0, 0]');
trans1 = 1 - E_ * 95 / 2 * j_;
trans2 = 1 - E_ * 45 / 2 * k_;

RTtotal = DQmult(trans1.vec8, trans2.vec8, R);
v8WorkPiece = DQmult(RTtotal, v8WorkPiece, DQconj(RTtotal));
v8WorkPiece = flipNormalsWorkpiece(v8WorkPiece);

% Assemble to fixture
stn = 2;
v8WorkPiece = assemblePrimSecTert(v8WorkPiece, fixDatums, Ps, stn);

% Nominal cutting planes
s2CuttingPlaneH = vec8(k_+E_*42.5);
s2CuttingPlaneV1 = vec8(i_+E_*85);
s2CuttingPlaneV2 = vec8(i_+E_*10);

% cutting plane
dTemp = deltas(:, 7);
dTwPrim = deltas(:, 8);

thetas = [0, 0, 0, 0];
Ds = [0, dTemp, 0, dTwPrim];
axis = [0, 0, 1; 0, 0, 1; 0, 0, 1; 0, 0, 1];
axisPoint = [0, 0, 0; 0, 0, 0; 0, 0, 0; 0, 0, 0];

% replace the machined surf
v8WorkPiece(:, 2) = getMachiningError(s2CuttingPlaneH, thetas, Ds, axis, axisPoint);
v8WorkPiece(:, 10) = getMachiningError(s2CuttingPlaneV1, thetas, Ds, axis, axisPoint);
v8WorkPiece(:, 11) = getMachiningError(s2CuttingPlaneV2, thetas, Ds, axis, axisPoint);
end

%
%%
function v8WorkPiece = operationStn3(v8WorkPiece, fixDatums, Ps, deltas)
%disp('Running Station 3 ...')

include_namespace_dq

% rotate first
R = rot2dquat(180, [1, 0, 0]');
trans1 = 1 - E_ * 95 / 2 * j_;
trans2 = 1 - E_ * 45 / 2 * k_;

RTtotal = DQmult(trans1.vec8, trans2.vec8, R);
v8WorkPiece = DQmult(RTtotal, v8WorkPiece, DQconj(RTtotal));
v8WorkPiece = flipNormalsWorkpiece(v8WorkPiece);

% Assemble to fixture
stn = 3;
v8WorkPiece = assemblePrimSecTert(v8WorkPiece, fixDatums, Ps, stn);

% Nominal cutting planes
s2CuttingPlaneH = vec8(k_+E_*37.5);
s2CuttingPlaneV = vec8(j_+E_*85);

% machining conditions
dTemp = deltas(:, 7);
dTwPrim = deltas(:, 8);

% Primary cutting edge
thetas = [0, 0, 0, 0];
Ds = [0, dTemp, 0, dTwPrim];
axis = [0, 0, 1; 0, 0, 1; 0, 0, 1; 0, 0, 1];
axisPoint = [0, 0, 0; 0, 0, 0; 0, 0, 0; 0, 0, 0];
v8WorkPiece(:, 4) = getMachiningError(s2CuttingPlaneH, thetas, Ds, axis, axisPoint);

% Secondary cutting edge
dTwSec = deltas(:, 9);
Ds = [0, dTemp, 0, dTwSec];
axis = [0, 0, 1; 0, 0, 1; 0, 0, 1; 0, 1, 0];
v8WorkPiece(:, 9) = getMachiningError(s2CuttingPlaneV, thetas, Ds, axis, axisPoint);
end

%
%%
function v8WorkPiece = assemblePrimSecTert(v8WorkPiece, fixDatums, Ps, stn)

include_namespace_dq

% get intersection lines and Direction based on fixture orientation
ULPS = checkAndFlipNormalDir(cross(fixDatums(2:4, 1), fixDatums(2:4, 2)));
ULPT = checkAndFlipNormalDir(cross(fixDatums(2:4, 1), fixDatums(2:4, 3)));

% Datums
switch stn
    case 1
        pDatum = 1;
        sDatum = 5;
    case 2
        pDatum = 3;
        sDatum = 7;
    case 3
        pDatum = 2;
        sDatum = 5;
end

tol = 10^-6;

% Step 1: Assembly of primary feature
%%
[R, errD] = getErrTransformationParas(fixDatums(:, 1), v8WorkPiece(:, pDatum), Ps, ULPS, 3);
v8WorkPiece = moveFeaturesBy(v8WorkPiece, R);

testPnts = getProjectedTestPointsPlucker2(v8WorkPiece(:,pDatum), Ps(1:3, :), fixDatums(2:4, 1)');
errD = Ps(1:3, :) - testPnts;
T = vec8(1-E_*errD(1, :)/2);
v8WorkPiece = moveFeaturesBy(v8WorkPiece, T);

% err = getProjectedTestPointsPlucker2(fixDatums(:, 1), Ps(1:3, :), fixDatums(2:4, 1)) - ...
%     getProjectedTestPointsPlucker2(v8WorkPiece(:, pDatum), Ps(1:3, :), fixDatums(2:4, 1));
% 
% assert(norm(err) < tol)
%disp('Passed primary check')

% Step 2: Assembly of secondary feature
%%
L4 = Plucker.pointdir(Ps(4, :), ULPT);
L5 = Plucker.pointdir(Ps(5, :), ULPT);
[p4, ~] = L4.intersect_plane2(v8WorkPiece(2:5, sDatum));
[p5, ~] = L5.intersect_plane2(v8WorkPiece(2:5, sDatum));
p4p5vec = p4 - p5;

% Rotate part to make it parallel with locators
alpha = rad2deg(anglePoints3d(normalize(Ps(4, :)-Ps(5, :)), normalize(p4p5vec)'));
if alpha > 90
    alpha = 180 - alpha;
end

R = rot2dquat(-alpha, fixDatums(2:4, 1));
v8WorkPiece = moveFeaturesBy(v8WorkPiece, R);

% check for equal distance from locators after rotation
L4 = Plucker.pointdir(Ps(4, :), -ULPT);
L5 = Plucker.pointdir(Ps(5, :), -ULPT);
[p4, ~] = L4.intersect_plane2(v8WorkPiece(2:5, sDatum));
[p5, ~] = L5.intersect_plane2(v8WorkPiece(2:5, sDatum));

err = Ps(4:5, :) - [p4'; p5'];
% assert(err(1, 2)-err(2, 2) < tol) % checks equal distance
 
T = vec8(1-E_*err(1, :)/2);
v8WorkPiece = moveFeaturesBy(v8WorkPiece, T);

% check for contact with secondary locators
L4 = Plucker.pointdir(Ps(4, :), ULPT);
L5 = Plucker.pointdir(Ps(5, :), ULPT);
[p4, ~] = L4.intersect_plane2(v8WorkPiece(2:5, sDatum));
[p5, ~] = L5.intersect_plane2(v8WorkPiece(2:5, sDatum));

% err2 = Ps(4:5, :) - [p4'; p5'];
% assert(abs(norm(err2(:, 2))) < tol);
%disp('Passed secondary check')

% Step 3: Assembly of Tertiary feature
%%
L6 = Plucker.pointdir(Ps(6, :), ULPS);
[p6, ~] = L6.intersect_plane2(v8WorkPiece(2:5, 6));

% Translate to teriary locator
errD = Ps(6, :) - p6';
T = vec8(1-E_*errD/2);
v8WorkPiece = moveFeaturesBy(v8WorkPiece, T);
v8WorkPiece(:, sDatum) = moveFeaturesBy(v8WorkPiece(:, sDatum), T);

% check for contact with tertiary after %displacement
[testPnts, ~] = L6.intersect_plane2(v8WorkPiece(2:5, 6));
assert(norm(Ps(6, 1)-testPnts(1)) < tol)

% check again
[p4, ~] = L4.intersect_plane2(v8WorkPiece(2:5, sDatum));
[p5, ~] = L5.intersect_plane2(v8WorkPiece(2:5, sDatum));
err2 = Ps(4:5, :) - [p4'; p5'];
assert(abs(norm(err2(:, 2))) < tol);

%disp('Passed tertiary check')
end
%%
