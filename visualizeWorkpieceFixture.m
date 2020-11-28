function visualizeWorkpieceFixtture(fixDatums, vSides, Ps)
% visualize given features of a part in a structure vSides

rng(2345)
include_namespace_dq

patchVertices(vSides.S1, 1, rand(1, 3)); hold on;
patchVertices(vSides.S2, 1, rand(1, 3)); hold on;
patchVertices(vSides.S3, 1, rand(1, 3)); hold on;
patchVertices(vSides.S4, 1, rand(1, 3)); hold on;
patchVertices(vSides.S5, 1, rand(1, 3)); hold on;
patchVertices(vSides.S6, 1, rand(1, 3)); hold on;
patchVertices(vSides.S7, 1, rand(1, 3)); hold on;
patchVertices(vSides.S8, 1, rand(1, 3)); hold on;
patchVertices(vSides.S9, 1, rand(1, 3)); hold on;
patchVertices(vSides.S10, 1, rand(1, 3)); hold on;
patchVertices(vSides.S11, 1, rand(1, 3)); hold on;
patchVertices(vSides.S12, 1, rand(1, 3)); hold on;
patchVertices(vSides.S13, 1, rand(1, 3)); hold on;

plot3(Ps(1:3, 1), Ps(1:3, 2), Ps(1:3, 3), 'g+', 'LineWidth', 2, 'MarkerSize', 10); hold on;
plot3(Ps(4:5, 1), Ps(4:5, 2), Ps(4:5, 3), 'b+', 'LineWidth', 2, 'MarkerSize', 10); hold on;
plot3(Ps(6, 1), Ps(6, 2), Ps(6, 3), 'y+', 'LineWidth', 2, 'MarkerSize', 10); hold on;
fs = 13;
text(Ps(:, 1), Ps(:, 2), Ps(:, 3), {'  L_1', '  L_2', '  L_3', '  L_4', '  L_5', '  L_6'}, 'FontSize', fs)
xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)'); grid off
view(135, 45)
set(gca, 'FontSize', fs)
end