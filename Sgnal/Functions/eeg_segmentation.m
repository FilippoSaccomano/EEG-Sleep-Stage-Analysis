function EEG_seg = eeg_segmentation(fs, EEG, epoch_duration)

seg_l = fs * epoch_duration; %epoch duration
n_seg = ceil(length(EEG) / seg_l);  

EEG_seg=zeros(n_seg,seg_l);


for i = 1:n_seg

    start_idx = (i-1) * seg_l + 1;
    end_idx = min(i * seg_l, length(EEG)); 
     
    seg = EEG(start_idx:end_idx);
    
    EEG_seg(i, 1:length(seg)) = seg;
end
end