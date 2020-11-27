function normal = checkAndFlipNormalDir(normal)
% flips the normal direction to positve sign

xyzDir = find(abs(normal) == max(abs(normal)));

if xyzDir == 3 && normal(3) < 0 % flip in z Direction
    normal = -normal;
elseif xyzDir == 2 && normal(2) < 0 % y Direction
    normal = -normal;
elseif xyzDir == 1 && normal(1) < 0 % in x Direction
    normal = -normal;
end
end