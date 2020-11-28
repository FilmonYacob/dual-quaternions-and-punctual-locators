function v8WorkPiece = moveToInspectionStation(v8WorkPiece,nPrim,nSec)
include_namespace_dq

% Transform to granite at inspection station
nominalPlane = vec8(k_);

[R, errD] = getErrTransformationParas(nominalPlane, v8WorkPiece(:, nPrim), [], [], 3);
errD = E_ * errD;
T = vec8(1-E_*errD.D/2*nominalPlane(2:4));
RT = DQmult(T, R);
v8WorkPiece = moveFeaturesBy(v8WorkPiece, RT);

tol = 10^-8;
err = getProjectedTestPointsPlucker2(nominalPlane, [0, 0, 0], nominalPlane(2:4, 1)) - ...
    getProjectedTestPointsPlucker2(v8WorkPiece(:, nPrim), [0, 0, 0], nominalPlane(2:4, 1));
assert(norm(err) < tol);

% Assemble to secondary
nominalPlaneJ = vec8(j_);
[R, errD] = getErrTransformationParas(nominalPlaneJ, v8WorkPiece(:, nSec), [], [], 2);
errD = E_ * errD;
T = vec8(1-E_*errD.D/2*nominalPlaneJ(2:4));
RT = DQmult(T, R);
v8WorkPiece = moveFeaturesBy(v8WorkPiece, RT);
%(check for primary)

tol = 10^-8;
err = getProjectedTestPointsPlucker2(nominalPlane, [0, 0, 0], nominalPlane(2:4, 1)) - ...
    getProjectedTestPointsPlucker2(v8WorkPiece(:, nPrim), [0, 0, 0], nominalPlane(2:4, 1));
assert(norm(err) < tol);
end