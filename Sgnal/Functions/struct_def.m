function [features_struct] = struct_def(features)
% STRUCT_DEF Initialize empty structure for feature storage
%
% Creates a structure with empty arrays for each feature name.
% This is used to initialize storage for spectral band powers and other
% features extracted from EEG epochs.
%
% Inputs:
%   features - Array of strings with feature names
%              (e.g., ["Delta", "Theta", "Alpha", "Beta", "Gamma", "Total"])
%
% Outputs:
%   features_struct - Structure with empty arrays for each feature
%
% Example:
%   features = ["Delta", "Theta", "Alpha"];
%   features_struct = struct_def(features);
%   % Creates: features_struct.Delta = []
%   %          features_struct.Theta = []
%   %          features_struct.Alpha = []
%
% See also: STRUCT

    % Initialize empty structure
    features_struct = struct();
    
    % Create empty array for each feature
    for i = 1:length(features)
        features_struct.(features(i)) = [];
    end
end
