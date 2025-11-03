% MAIN_PIPELINE - Complete EEG Sleep Stage Analysis Pipeline
%
% This script runs the complete automated pipeline for EEG sleep stage
% analysis, from raw data loading to hypnogram generation.
%
% REQUIREMENTS:
%   - MATLAB R2019b or later
%   - Signal Processing Toolbox
%   - Statistics and Machine Learning Toolbox
%   - Input data file in .mat format (see DATA_FORMAT.md)
%
% WORKFLOW:
%   1. Data acquisition and visualization
%   2. Noise filtering (1Hz and 2Hz notch filters)
%   3. Epoch segmentation (30-second windows)
%   4. Power spectral density calculation
%   5. Feature extraction (frequency band powers)
%   6. Entropy analysis (Sample and Approximate Entropy)
%   7. Sleep stage classification
%   8. Hypnogram generation and visualization
%
% OUTPUTS:
%   - Multiple figures showing signal analysis results
%   - Hypnogram of sleep stage progression
%   - Sleep stage statistics
%
% To use this script:
%   1. Place your data.mat file in the data/ directory
%   2. Ensure data.mat contains 'dati' struct with 'eeg' and 'fs' fields
%   3. Run this script in MATLAB
%
% For data format requirements, see DATA_FORMAT.md
%
% Author: Filippo Saccomano
% Last modified: 2025

%% INITIALIZATION
close all           % Close all figures
clear variables     % Clear workspace
tic()              % Start timer

% Add functions to MATLAB path
addpath('src');

%% CONFIGURATION PARAMETERS
% Input data file
file_name = "data/data.mat";

% Epoch configuration
epoch_duration = 30;  % Duration of each epoch in seconds (standard for sleep analysis)

% Frequency band definitions
features = ["Delta", "Theta", "Alpha", "Beta", "Gamma", "Total"];
freq_ranges = {
    [1, 4];      % Delta: deep sleep
    [4, 8];      % Theta: light sleep, drowsiness
    [8, 12];     % Alpha: relaxed wakefulness
    [12, 30];    % Beta: active thinking, alertness
    [30, 50];    % Gamma: cognitive processing
    [1, 50];     % Total: overall power
};

%% STEP 1: DATA ACQUISITION
fprintf('Loading EEG data...\n');
[EEG, fs, t] = data_acquisition(file_name);
fprintf('Data loaded: %d samples at %d Hz (%.1f minutes)\n', ...
        length(EEG), fs, length(EEG)/fs/60);

%% STEP 2: VISUALIZE RAW SIGNAL
fprintf('Plotting original EEG signal and FFT...\n');
plot_eeg_fft(t, EEG, fs);

%% STEP 3: NOISE FILTERING
fprintf('Applying notch filters (1Hz and 2Hz)...\n');
[EEG_filtered] = double_notch_filter(fs, EEG, t, 1, 2);

%% STEP 4: EPOCH SEGMENTATION
fprintf('Segmenting signal into %d-second epochs...\n', epoch_duration);
EEG_seg = eeg_segmentation(fs, EEG_filtered, epoch_duration);
fprintf('Created %d epochs\n', size(EEG_seg, 1));

%% STEP 5: POWER SPECTRAL DENSITY CALCULATION
fprintf('Calculating PSD for each epoch...\n');
window_dim = 5;  % Window dimension in seconds for Welch's method
[PSD_EEG, f3] = psd_calc(EEG_seg, fs, window_dim);

%% STEP 6: FEATURE EXTRACTION - Band Power

% Initialize structures
fprintf('Extracting spectral features...\n');
[features_struct] = struct_def(features);
psd_struct = struct_def(features);

% Calculate absolute power in each frequency band
[features_struct, psd_struct, struct_len] = power_calc(PSD_EEG, features, f3, ...
                                                        features_struct, freq_ranges, psd_struct);

% Calculate relative power percentages
features_perc = perc_calc(features, PSD_EEG, features_struct);

%% STEP 7: STATISTICAL FEATURE ANALYSIS

fprintf('Computing mean and standard deviation for each band...\n');
features_mean = struct();
features_std = struct();

for i = 1:length(features)
    features_mean.(features(i)) = mean(features_perc.(features(i)));
    features_std.(features(i)) = std(features_perc.(features(i)));
end

%% STEP 8: ENTROPY ANALYSIS

fprintf('Calculating Sample Entropy and Approximate Entropy...\n');
m = 2;      % Embedding dimension for entropy calculation
r = 0.2;    % Tolerance parameter

SampEn_values = zeros(1, size(EEG_seg, 1));
ApEn_values = zeros(1, size(EEG_seg, 1));

for epoch = 1:size(EEG_seg, 1)
    % Sample Entropy: measures complexity/irregularity
    SampEn_values(epoch) = sample_entropy(EEG_seg(epoch, :), m, r, 'chebychev');
    
    % Approximate Entropy: measures regularity
    ApEn_values(epoch) = approximateEntropy(EEG_seg(epoch, :));
end

%% STEP 9: SLEEP STAGE CLASSIFICATION

fprintf('Classifying sleep stages...\n');
sleep_stage = zeros(1, struct_len);

% Rule-based classification using spectral power ratios
for i = 1:struct_len
    % Awake: High Alpha and Beta activity
    if (features_perc.Alpha(i) > features_mean.Alpha + features_std.Alpha) && ...
       (features_perc.Beta(i) > features_mean.Beta)
        sleep_stage(i) = 0;  % Awake
        
    % NREM: High Delta activity (deep sleep)
    elseif (features_perc.Delta(i) > features_mean.Delta - features_std.Delta)
        sleep_stage(i) = 2;  % NREM
        
    % REM: Moderate Beta and Theta activity
    elseif (features_perc.Beta(i) > features_mean.Beta - features_std.Beta) && ...
           (features_perc.Theta(i) > features_mean.Theta)
        sleep_stage(i) = 1;  % REM
    end
end

%% STEP 10: CALCULATE INITIAL SLEEP STAGE STATISTICS

fprintf('Calculating sleep stage percentages...\n');
sleep_stage_perc = zeros(1, 3);

for i = 1:length(sleep_stage)
    if sleep_stage(i) == 0
        sleep_stage_perc(1) = sleep_stage_perc(1) + 1;  % Awake
    elseif sleep_stage(i) == 1
        sleep_stage_perc(2) = sleep_stage_perc(2) + 1;  % REM
    else
        sleep_stage_perc(3) = sleep_stage_perc(3) + 1;  % NREM
    end
end

%% STEP 11: SMOOTH HYPNOGRAM

fprintf('Smoothing hypnogram...\n');
min_duration = 6;  % Minimum number of consecutive epochs for stage stability
filtered_sleep_stage = filtered_sleep_stages_def(sleep_stage, min_duration);

% Recalculate percentages after smoothing
sleep_stage_perc = zeros(1, 3);

for i = 1:length(filtered_sleep_stage)
    if filtered_sleep_stage(i) == 0
        sleep_stage_perc(1) = sleep_stage_perc(1) + 1;
    elseif filtered_sleep_stage(i) == 1
        sleep_stage_perc(2) = sleep_stage_perc(2) + 1;
    else
        sleep_stage_perc(3) = sleep_stage_perc(3) + 1;
    end
end

sleep_stage_perc = sleep_stage_perc / length(sleep_stage);

%% STEP 12: GENERATE HYPNOGRAM

fprintf('Generating hypnogram...\n');
t_min = hypnogram(filtered_sleep_stage, epoch_duration);

%% STEP 13: VISUALIZE HYPNOGRAM WITH SAMPLE ENTROPY

fprintf('Creating combined hypnogram with Sample Entropy overlay...\n');

% Copy hypnogram figure
fig1 = figure(6);
fig2 = copyobj(fig1, 0);

% Make background elements semi-transparent
axes_in_fig2 = findall(fig2, 'Type', 'axes');
patch_in_fig2 = findall(axes_in_fig2, 'Type', 'patch');
rectangles_in_fig2 = findall(axes_in_fig2, 'Type', 'rectangle');
set(patch_in_fig2, 'FaceAlpha', 0.5);
set(rectangles_in_fig2, 'FaceAlpha', 0.5);

% Add Sample Entropy on second y-axis
hold on
yyaxis right
plot([0, 0, t_min], SampEn_values, 'LineWidth', 1.3)
ax = gca;
ax.YAxis(2).Color = 'black';
xlim tight
ylabel("Sample Entropy", "Color", [0 0 0])
title("Hypnogram vs Sample Entropy");

%% DISPLAY RESULTS

fprintf('\n========== ANALYSIS COMPLETE ==========\n');
fprintf('Total recording duration: %.1f minutes\n', max(t_min));
fprintf('Number of epochs analyzed: %d\n', struct_len);
fprintf('\nSleep Stage Distribution:\n');
fprintf('  Awake: %.1f%%\n', sleep_stage_perc(1) * 100);
fprintf('  REM:   %.1f%%\n', sleep_stage_perc(2) * 100);
fprintf('  NREM:  %.1f%%\n', sleep_stage_perc(3) * 100);
fprintf('\nExecution time: %.2f seconds\n', toc);
fprintf('======================================\n\n');

fprintf('Analysis complete! Check the generated figures for results.\n');
