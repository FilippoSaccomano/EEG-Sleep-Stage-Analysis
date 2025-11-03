function [features_struct] = struct_def(features)
    features_struct = struct();
    for i = 1:length(features)
        features_struct.(features(i)) = [];
    end
end
