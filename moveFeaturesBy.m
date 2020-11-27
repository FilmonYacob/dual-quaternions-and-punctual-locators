function movedFeatures = moveFeaturesBy(features, RT)
% Transforms given feeatres by a tranformation operator RT

include_namespace_dq

movedFeatures = zeros(8, size(features, 2));

for f = 1:size(features, 2)
    movedFeatures(:, f) = DQmult(RT, features(:, f), DQconj(RT));
    movedFeatures(2:4, f) = normalize(movedFeatures(2:4, f));

    normal = movedFeatures(2:4, f);
    if normal(find(abs(normal) == max(abs(normal)))) < 0
        movedFeatures(:, f) = -movedFeatures(:, f);
    end
end
end