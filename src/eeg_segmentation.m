function EEG_seg = eeg_segmentation(fs, EEG, epoch_duration)
% EEG_SEGMENTATION Divide continuous EEG signal into fixed-duration epochs
%
% Segments a continuous EEG recording into non-overlapping epochs of
% specified duration. This is a standard preprocessing step for sleep
% stage analysis where each epoch is typically 30 seconds.
%
% Inputs:
%   fs             - Sampling frequency in Hz (scalar)
%   EEG            - Continuous EEG signal vector (1 x N samples)
%   epoch_duration - Duration of each epoch in seconds (typically 30)
%
% Outputs:
%   EEG_seg - Matrix of segmented EEG (n_epochs x samples_per_epoch)
%             Each row represents one epoch
%
% Example:
%   EEG_seg = eeg_segmentation(100, EEG, 30);
%   % Creates 30-second epochs at 100 Hz (3000 samples per epoch)
%
% Note:
%   - If the signal length is not perfectly divisible by epoch_duration,
%     the last epoch will be zero-padded
%
% See also: RESHAPE

    % Calculate samples per epoch
    seg_l = fs * epoch_duration;
    
    % Calculate number of epochs needed (round up to include partial epoch)
    n_seg = ceil(length(EEG) / seg_l);
    
    % Pre-allocate output matrix (zero-padded)
    EEG_seg = zeros(n_seg, seg_l);
    
    % Extract each epoch
    for i = 1:n_seg
        % Calculate start and end indices for this epoch
        start_idx = (i-1) * seg_l + 1;
        end_idx = min(i * seg_l, length(EEG));  % Don't exceed signal length
        
        % Extract segment
        seg = EEG(start_idx:end_idx);
        
        % Store in output matrix (zero-padded if last segment is short)
        EEG_seg(i, 1:length(seg)) = seg;
    end
end