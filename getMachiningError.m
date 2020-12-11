function planeWithMachErr = getMachiningError(mPlane, thetas, Ds, axis, axisPoint)
% (1) geometric, kinematic, thermal variations of the machine tool axes,
% (2) spindle-thermal variations,theta assumed 0
% (3) cutting-force induced variation,
% (4) cutting-tool wear-induced variation.

include_namespace_dq

sigmas = [];
 
for i = 1:4
    sigmas = [sigmas, screw2dquat(thetas(i), -Ds(i), axis(i, :), axisPoint(i, :))];
end
    sigmasPi = DQmult(sigmas(:, 1), sigmas(:, 2), sigmas(:, 3), sigmas(:, 4));
    planeWithMachErr = moveFeaturesBy(mPlane,sigmasPi);
end
