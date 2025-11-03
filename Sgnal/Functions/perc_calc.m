function features_perc = perc_calc(features, PSD_EEG, features_struct)
features_perc = struct();
for i = 1:length(features)
    features_perc.(features(i)) = [];  
end

for seg=1:size(PSD_EEG, 1)
    power_tot=features_struct.Total(seg);
    for i=1:length(features)
        band_power=features_struct.(features(i))(seg);
        band_perc=band_power/power_tot;
        features_perc.(features(i))(seg)=band_perc;
    end
end
end