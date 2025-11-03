function [features_struct, psd_struct, struct_len] = power_calc(PSD_EEG, features, f3, features_struct, freq_ranges, psd_struct)

for seg = 1:size(PSD_EEG, 1)  
    for i = 1:length(features)
        freq_idx = find(f3 >= freq_ranges{i}(1) & f3 <= freq_ranges{i}(2));
        
        psd_band = PSD_EEG(seg, freq_idx);
        psd_struct.(features(i)){seg} = psd_band;
        band_power = trapz(f3(freq_idx), PSD_EEG(seg, freq_idx));  
        features_struct.(features(i))(seg) = band_power;
    end
end
    struct_len=length(features_struct.Alpha);
end