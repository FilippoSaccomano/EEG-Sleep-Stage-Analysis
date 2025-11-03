function features_perc = perc_calc(features, PSD_EEG, features_struct)
% PERC_CALC Calculate relative power percentages for each frequency band
%
% Converts absolute band powers to relative percentages by dividing each
% band's power by the total power. This normalization helps in comparing
% spectral patterns across different epochs and subjects.
%
% Inputs:
%   features        - Array of feature names (e.g., ["Delta", "Theta", "Alpha"])
%   PSD_EEG         - Power spectral density matrix (n_epochs x n_frequencies)
%                     (not directly used, kept for interface compatibility)
%   features_struct - Structure with absolute band powers (from power_calc)
%                     Must contain 'Total' field with total power per epoch
%
% Outputs:
%   features_perc - Structure with relative power percentages (0-1)
%                   Each field contains vector of length n_epochs
%
% Example:
%   features_perc = perc_calc(features, PSD_EEG, features_struct);
%   % features_perc.Delta(i) = Delta power / Total power for epoch i
%
% Note:
%   Relative power is useful for sleep stage classification as it normalizes
%   for overall signal amplitude variations between epochs.
%
% See also: POWER_CALC

    % Initialize output structure
    features_perc = struct();
    for i = 1:length(features)
        features_perc.(features(i)) = [];
    end
    
    % Calculate percentage for each epoch
    for seg = 1:size(PSD_EEG, 1)
        % Get total power for this epoch
        power_tot = features_struct.Total(seg);
        
        % Calculate percentage for each band
        for i = 1:length(features)
            band_power = features_struct.(features(i))(seg);
            band_perc = band_power / power_tot;  % Relative power (0-1)
            features_perc.(features(i))(seg) = band_perc;
        end
    end
end