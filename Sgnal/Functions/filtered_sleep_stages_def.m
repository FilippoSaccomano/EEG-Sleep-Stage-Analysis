function sleep_stage_filtered = filtered_sleep_stages_def(sleep_stage, min_duration)
% FILTERED_SLEEP_STAGES_DEF Smooth sleep stage transitions using median filtering
%
% Smooths the classified sleep stages by applying a sliding median filter.
% This removes brief transitions between sleep stages that are likely
% artifacts or misclassifications, following the principle that sleep
% stages typically last for multiple consecutive epochs.
%
% Inputs:
%   sleep_stage  - Vector of classified sleep stages (0=Awake, 1=REM, 2=NREM)
%   min_duration - Number of consecutive epochs to use for median filtering
%                  (typically 6, representing 3 minutes with 30-second epochs)
%
% Outputs:
%   sleep_stage_filtered - Smoothed sleep stage vector
%
% Example:
%   sleep_stage_filtered = filtered_sleep_stages_def(sleep_stage, 6);
%   % Applies 6-epoch (3-minute) median smoothing
%
% Method:
%   For each window of min_duration epochs, replaces all values with the
%   median value of that window. This ensures brief state changes are
%   smoothed out while preserving genuine sleep stage transitions.
%
% Note:
%   This implements a simplified version of sleep stage smoothing rules
%   used in polysomnography, where brief arousals or stage transitions
%   shorter than a certain duration are typically ignored.
%
% See also: MEDIAN, ROUND

    % Process signal in non-overlapping windows of min_duration epochs
    for i = 1:(min_duration):(length(sleep_stage)-min_duration)
        % Calculate median sleep stage for this window
        m = round(median(sleep_stage(i:i+min_duration-1)));
        
        % Set all epochs in window to the median value
        sleep_stage_filtered(i:i+min_duration-1) = m;
    end
end
