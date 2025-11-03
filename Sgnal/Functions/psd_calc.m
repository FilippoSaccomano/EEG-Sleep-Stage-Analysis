function [PSD_EEG, f3] = psd_calc(EEG_seg, fs, window_dim)
noverlap = 100/2;
PSD_EEG=[];
for i=1:size(EEG_seg,1)
    [PSDw_3,f3] = pwelch(EEG_seg(i,:),hamming(fs*window_dim),noverlap,1024,fs); 
    PSD_EEG=[PSD_EEG,PSDw_3];
end

PSD_EEG=transpose(PSD_EEG);
PSD_EEG_tot=mean(PSD_EEG,1);

figure;
plot(f3,PSD_EEG_tot)
title("PSD MEAN EPOCH")
end