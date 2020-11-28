function [R, errD] = getErrTransformationParas(dqRefFeature, dqMovingFeature, Ps, ULPS, xyzDir)
% gets tranfomation operators Rotation R and Translation ERRD for inputs
% input reference and moving feature dual quaternions, locator points PS,
% the direction of the displacement towards tertiary ULPS and assembly
% direction XYZDIR
include_namespace_dq
dqRefFeature = DQ(dqRefFeature);
dqMovingFeature = DQ(dqMovingFeature);
normalRef = dqRefFeature.P.vec3;
normalFeature = dqMovingFeature.P.vec3;

global aOfRotation
switch xyzDir
    case 2
        axisOfRotation = aOfRotation;
    case 1
        % No rotation in this axis
        R = zeros(8, 1); R(1) = 1;
        newTerPlane = DQ(normalize(ULPS)) + E_ * norm(Ps(6, :)*ULPS);

        errD = newTerPlane - dqMovingFeature;
        dqRefFeature = newTerPlane;
        normalRef = dqRefFeature.P.vec3;

    case 3
        axisOfRotation = getMyNormal([0, 0, 0], normalRef', normalFeature');
        aOfRotation = normalRef;
end

% Rotation is needed only in direction of x-1 and z-3
if xyzDir == 2 || xyzDir == 3
    alpha = rad2deg(anglePoints3d(normalRef', normalFeature'));

    if xyzDir == 2
        % project vectors to horizontal plane
        normalRef(3) = 0;
        normalFeature(3) = 0;
        alpha = rad2deg(anglePoints3d(normalRef', normalFeature'));
    end

    if alpha > 90
        alpha = 180 - alpha;
    end
    %%
    R = rot2dquat(alpha, axisOfRotation');
    movedFeature = moveFeaturesBy(dqMovingFeature.vec8, R);
    
    refDir = normalize(dqRefFeature.P.vec3);
    movedDir = normalize(DQ(movedFeature).P.vec3);
    f = find(abs(refDir) == max(abs(refDir)));
    r = refDir(f) / movedDir(f);
    tol = 10e-8;

    if abs(movedDir(1)*r-refDir(1)*r) > tol & abs(movedDir(2)*r-refDir(2)*r) > tol
        R = rot2dquat(-alpha, axisOfRotation');
        movedFeature = DQmult(R, dqMovingFeature.vec8, DQconj(R));
    end

    dqRefFeature = dqRefFeature.vec8;
    errTT = getProjectedTestPointsPlucker2(dqRefFeature, [0, 0, 0], normalRef) - ...
        getProjectedTestPointsPlucker2(movedFeature, [0, 0, 0], normalRef);
    errD = errTT * normalRef;
end
end
