function [features_struct, psd_struct, struct_len] = power_calc(PSD_EEG, features, f3, features_struct, freq_ranges, psd_struct)
% POWER_CALC Calculate power in specified frequency bands for each epoch
%
% Computes the total power within specified frequency bands (Delta, Theta,
% Alpha, Beta, Gamma) for each EEG epoch. Power is calculated by integrating
% the PSD over the frequency range using trapezoidal integration.
%
% Inputs:
%   PSD_EEG        - Power spectral density matrix (n_epochs x n_frequencies)
%   features       - Array of feature names (e.g., ["Delta", "Theta", "Alpha"])
%   f3             - Frequency vector in Hz (1 x n_frequencies)
%   features_struct- Structure to store band powers (initialized with struct_def)
%   freq_ranges    - Cell array of frequency ranges {[low1, high1]; [low2, high2]; ...}
%                    Example: {[1,4]; [4,8]; [8,12]; [12,30]; [30,50]; [1,50]}
%                    for Delta, Theta, Alpha, Beta, Gamma, Total
%   psd_struct     - Optional structure to store PSD values per band
%
% Outputs:
%   features_struct - Updated structure with band powers for each epoch
%                     (each field contains vector of length n_epochs)
%   psd_struct      - Structure containing PSD values for each band and epoch
%   struct_len      - Number of epochs processed
%
% Example:
%   freq_ranges = {[1,4]; [4,8]; [8,12]};  % Delta, Theta, Alpha
%   features = ["Delta", "Theta", "Alpha"];
%   [features_struct, psd_struct, n] = power_calc(PSD_EEG, features, f3, ...
%                                                  features_struct, freq_ranges, psd_struct);
%
% See also: TRAPZ, FIND

    % Process each epoch
    for seg = 1:size(PSD_EEG, 1)
        % Process each frequency band
        for i = 1:length(features)
            % Find frequency indices within the band range
            freq_idx = find(f3 >= freq_ranges{i}(1) & f3 <= freq_ranges{i}(2));
            
            % Extract PSD values for this band
            psd_band = PSD_EEG(seg, freq_idx);
            psd_struct.(features(i)){seg} = psd_band;
            
            % Calculate band power using trapezoidal integration
            % Power = integral of PSD over frequency range
            band_power = trapz(f3(freq_idx), PSD_EEG(seg, freq_idx));
            
            % Store band power for this epoch
            features_struct.(features(i))(seg) = band_power;
        end
    end
    
    % Return number of epochs processed
    struct_len = length(features_struct.Alpha);
end