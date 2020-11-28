function vSides = getSidesFromPlaneIntersections(v8WorkPiece)

m1 = getPlaneIntersections(v8WorkPiece(:, 5:8), v8WorkPiece(:, 1));
Vs.v1 = m1(1, :);
Vs.v2 = m1(2, :);
Vs.v3 = m1(3, :);
Vs.v4 = m1(4, :);

m2 = getPlaneIntersections(v8WorkPiece(:, 5:8), v8WorkPiece(:, 3));
Vs.v5 = m2(1, :);
Vs.v6 = m2(2, :);
Vs.v7 = m2(3, :);
Vs.v8 = m2(4, :);

v8WorkPieceCutSides = [v8WorkPiece(:, 5), v8WorkPiece(:, 7), v8WorkPiece(:, 10:11)];
m3 = getPlaneIntersections(v8WorkPieceCutSides, v8WorkPiece(:, 2));

Vs.v9 = m3(1, :);
Vs.v10 = m3(2, :);
Vs.v11 = m3(3, :);
Vs.v12 = m3(4, :);

v8WorkPieceCutSides = [v8WorkPiece(:, 10:11), v8WorkPiece(:, 5), v8WorkPiece(:, 7)];
m4 = getPlaneIntersections(v8WorkPieceCutSides, v8WorkPiece(:, 1));
Vs.v13 = m4(1, :);
Vs.v14 = m4(2, :);
Vs.v15 = m4(3, :);
Vs.v16 = m4(4, :);

m5 = getPlaneIntersections(v8WorkPiece(:, 6:9), v8WorkPiece(:, 4));
Vs.v17 = m5(1, :);
Vs.v18 = m5(2, :);
Vs.v19 = m5(3, :);
Vs.v20 = m5(4, :);


v8WorkPieceCutSides = [v8WorkPiece(:, 3:4), v8WorkPiece(:, 6:8)];
m6 = getPlaneIntersections(v8WorkPieceCutSides, v8WorkPiece(:, 9));
Vs.v21 = m6(1, :);
Vs.v22 = m6(2, :);
Vs.v23 = m6(3, :);
Vs.v24 = m6(4, :);

vSides.S1 = [Vs.v1; Vs.v2; Vs.v3; Vs.v4];
vSides.S2 = [Vs.v5; Vs.v6; Vs.v7; Vs.v8];
vSides.S3 = [Vs.v4; Vs.v8; Vs.v7; Vs.v3];
vSides.S4 = [Vs.v1; Vs.v5; Vs.v8; Vs.v4];
vSides.S5 = [Vs.v1; Vs.v5; Vs.v6; Vs.v2];
vSides.S6 = [Vs.v2; Vs.v6; Vs.v7; Vs.v3];
vSides.S7 = [Vs.v9; Vs.v10; Vs.v11; Vs.v12];
vSides.S8 = [Vs.v9; Vs.v13; Vs.v16; Vs.v12];
vSides.S9 = [Vs.v10; Vs.v14; Vs.v15; Vs.v11];
vSides.S10 = [Vs.v17; Vs.v18; Vs.v19; Vs.v20];
vSides.S11 = [Vs.v21; Vs.v22; Vs.v23; Vs.v24];
vSides.S12 = [Vs.v11; Vs.v12; Vs.v16; Vs.v15];
vSides.S13 = [Vs.v9; Vs.v10; Vs.v14; Vs.v13];

vSides.S14 = [Vs.v3; Vs.v2; Vs.v18; Vs.v19];
vSides.S15 = [Vs.v5; Vs.v8; Vs.v23; Vs.v22];

Ms = [m1; m2; m3; m4; m5; m6];

% f = fieldnames(Vs);
% s = 1:size(f, 1);
% for s = 1:size(f, 1)
%     V = Vs.(string(f(s, 1)));
%     text(V(1), V(2), V(3), num2str(s)); hold on;
% end
%  scatter3(Ms(:,1),Ms(:,2),Ms(:,3),'r*');
% view(3)
end