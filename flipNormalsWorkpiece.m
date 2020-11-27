function v8WorkPieceFlip = flipNormalsWorkpiece(v8WorkPiece)
% makes sure the plane normal point in positive direction

include_namespace_dq

v8WorkPieceFlip = zeros(8, size(v8WorkPiece, 2));
 
for f = 1:size(v8WorkPiece, 2)
    normal = v8WorkPiece(2:4, f);
    if normal(find(abs(normal) == max(abs(normal)))) < 0
        v8WorkPieceFlip(:, f) = -v8WorkPiece(:, f);
    else
        v8WorkPieceFlip(:, f) = v8WorkPiece(:, f);
    end
end
end