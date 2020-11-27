
function [mshPts, planeEquation] = getAPlane(P1,P2,P3,C,xyzDir)
% gets a normal
normal = cross(P1-P2,P1-P3);
% normal = normal / sum(abs(normal));
normal = normalize(normal);
if xyzDir == 3 && normal(3) < 0 % flip in z Direction
    normal = -normal;
elseif xyzDir == 2 && normal(2) < 0 % y Direction
    normal = -normal;
elseif xyzDir == 1 && normal(1) < 0 % in x Direction
    normal = -normal;
end
D = (P1(1) * normal(1) + P1(2) * normal(2) + P1(3) * normal(3));
 
X = C(:,1); Y = C(:,2); Z = C(:,3);

% For orthogonal cases
switch xyzDir
    case 3 % z Direction
        Z = -(-D + (normal(1) * X) + (normal(2) * Y)) / normal(3);
    case 2 % y Direction
        Y = -(-D + (normal(1) * X) + (normal(3) * Z)) / normal(2);
    case 1 % in x Direction
        X = -(-D + (normal(3) * Z) + (normal(2) * Y)) / normal(1);
end
mshPts = [X(:),Y(:),Z(:)];
planeEquation = [normal,D];
end