function [fixDatums, Ps] = getAllFixturePlanes(Ps,x)
% convertes Punctual locaotrs with x deviations to dual quaternions

include_namespace_dq

Ps(1,3) = Ps(1,3)+ x(1);
Ps(2,3) = Ps(2,3)+ x(2);
Ps(3,3) = Ps(3,3)+ x(3);
Ps(4,2) = Ps(4,2)+ x(4);
Ps(5,2) = Ps(5,2)+ x(5);
Ps(6,1) = Ps(6,1)+ x(6);

P1 = Ps(1,:);
P2 = Ps(2,:);
P3 = Ps(3,:);
P4 = Ps(4,:);
P5 = Ps(5,:);
P6 = Ps(6,:);

P45 = [P4(1) P4(2) 0];
 
[~, planeEquation] = getAPlane(P1,P2,P3,P1,3);
primaryF = getDQPlane(planeEquation(1:3),P3);

[~, planeEquation] = getAPlane(P4,P5,P45,P4,2);
secondaryF = getDQPlane(planeEquation(1:3),P4);

P61 = [ P6(1) P1(2) P1(3)];
P62 = [ P6(1) P2(2) P2(3)];
[~, planeEquation] = getAPlane(P6,P61,P62,P6,1);
tertiaryF = getDQPlane(planeEquation(1:3),P6);

fixDatums.PrimaryF   = primaryF;
fixDatums.SecondaryF = secondaryF;
fixDatums.TertiaryF  = tertiaryF;
end
