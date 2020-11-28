function iPts = getPlaneIntersections(v8WorkPieceCutSides, cuttingPlane)
include_namespace_dq

% Checks intersection against all features
plane1 = cuttingPlane(2:5);
iPts = [];

cutSides = 1:size(v8WorkPieceCutSides, 2);

for s = cutSides
    plane2 = (v8WorkPieceCutSides(2:5, s))'; % equation of the rest of the planes.
    LP = Plucker.planes(plane1, plane2);

    for s2 = cutSides
        plane = (v8WorkPieceCutSides(2:5, s2))';
        [p, ~] = LP.intersect_plane(plane);
        if ~isempty(p) && norm(p) < 250 % interesections close to the orgin
            iPts = [iPts; p'];
        end
    end
end

% Order points for patching
tol = 10^-7;

iPts = uniquetol(iPts, tol, 'ByRows', true);
iPts = -iPts;
iPts = sortrows(iPts);
f1 = find(iPts(1:2, 2) == min(iPts(1:2, 2)));
f2 = find(iPts(2, 1:2) == max(iPts(2, 1:2)));
f3 = find(iPts(3, 1:2) == max(iPts(3, 1:2)));

if f1 ~= 1
    % change order of points
    iPtsTemp = iPts;
    iPtsTemp(1, :) = iPts(2, :);
    iPtsTemp(2, :) = iPts(1, :);
    iPts = iPtsTemp;
end

if f3 ~= f2
    % change order of points
    iPtsTemp = iPts;
    iPtsTemp(3, :) = iPts(4, :);
    iPtsTemp(4, :) = iPts(3, :);
    iPts = iPtsTemp;
end
end
