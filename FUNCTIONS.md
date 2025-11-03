# Function Reference

This document provides detailed information about each function in the EEG Sleep Stage Analysis pipeline.

## Core Functions

### data_acquisition.m
**Purpose**: Load EEG data from .mat file

**Syntax**:
```matlab
[EEG, fs, t] = data_acquisition(file_name)
```

**Inputs**:
- `file_name` - String path to .mat file containing 'dati' struct

**Outputs**:
- `EEG` - EEG signal vector (1 x N samples) in microvolts
- `fs` - Sampling frequency in Hz
- `t` - Time vector in seconds

**Example**:
```matlab
[EEG, fs, t] = data_acquisition("data/data.mat");
```

---

### plot_eeg_fft.m
**Purpose**: Visualize raw EEG signal and its frequency spectrum

**Syntax**:
```matlab
plot_eeg_fft(t, EEG, fs)
```

**Inputs**:
- `t` - Time vector in seconds
- `EEG` - EEG signal amplitude in microvolts
- `fs` - Sampling frequency in Hz

**Outputs**:
- None (generates figure with two subplots)

**Example**:
```matlab
plot_eeg_fft(t, EEG, 100);
```

---

### double_notch_filter.m
**Purpose**: Apply two notch filters to remove specific frequency noise

**Syntax**:
```matlab
[EEG_filtered] = double_notch_filter(fs, EEG, t, Fcut1, Fcut2)
```

**Inputs**:
- `fs` - Sampling frequency in Hz
- `EEG` - Raw EEG signal vector
- `t` - Time vector in seconds
- `Fcut1` - First cutoff frequency in Hz (typically 1 Hz)
- `Fcut2` - Second cutoff frequency in Hz (typically 2 Hz)

**Outputs**:
- `EEG_filtered` - Filtered EEG signal vector

**Example**:
```matlab
EEG_filtered = double_notch_filter(100, EEG, t, 1, 2);
```

**Notes**:
- Uses IIR notch filters with Q=90
- Applies zero-phase filtering (filtfilt)
- Generates three figures showing filter responses and results

---

### eeg_segmentation.m
**Purpose**: Divide continuous EEG signal into fixed-duration epochs

**Syntax**:
```matlab
EEG_seg = eeg_segmentation(fs, EEG, epoch_duration)
```

**Inputs**:
- `fs` - Sampling frequency in Hz
- `EEG` - Continuous EEG signal vector
- `epoch_duration` - Duration of each epoch in seconds (typically 30)

**Outputs**:
- `EEG_seg` - Matrix of segmented EEG (n_epochs x samples_per_epoch)

**Example**:
```matlab
EEG_seg = eeg_segmentation(100, EEG_filtered, 30);
```

**Notes**:
- Last epoch is zero-padded if signal length is not perfectly divisible
- Each row represents one epoch

---

### psd_calc.m
**Purpose**: Calculate Power Spectral Density for each EEG epoch

**Syntax**:
```matlab
[PSD_EEG, f3] = psd_calc(EEG_seg, fs, window_dim)
```

**Inputs**:
- `EEG_seg` - Matrix of EEG epochs (n_epochs x samples_per_epoch)
- `fs` - Sampling frequency in Hz
- `window_dim` - Window duration in seconds for Welch's method (typically 5)

**Outputs**:
- `PSD_EEG` - Power spectral density matrix (n_epochs x n_frequencies)
- `f3` - Frequency vector in Hz

**Example**:
```matlab
[PSD_EEG, f3] = psd_calc(EEG_seg, 100, 5);
```

**Notes**:
- Uses Welch's method with Hamming windows
- 50% overlap between windows
- 1024-point FFT
- Generates figure showing mean PSD

---

### struct_def.m
**Purpose**: Initialize empty structure for feature storage

**Syntax**:
```matlab
[features_struct] = struct_def(features)
```

**Inputs**:
- `features` - Array of strings with feature names

**Outputs**:
- `features_struct` - Structure with empty arrays for each feature

**Example**:
```matlab
features = ["Delta", "Theta", "Alpha", "Beta", "Gamma", "Total"];
features_struct = struct_def(features);
```

---

### power_calc.m
**Purpose**: Calculate power in specified frequency bands for each epoch

**Syntax**:
```matlab
[features_struct, psd_struct, struct_len] = power_calc(PSD_EEG, features, f3, features_struct, freq_ranges, psd_struct)
```

**Inputs**:
- `PSD_EEG` - Power spectral density matrix
- `features` - Array of feature names
- `f3` - Frequency vector in Hz
- `features_struct` - Structure to store band powers
- `freq_ranges` - Cell array of frequency ranges
- `psd_struct` - Structure to store PSD values per band

**Outputs**:
- `features_struct` - Updated structure with band powers
- `psd_struct` - Structure with PSD values for each band
- `struct_len` - Number of epochs processed

**Example**:
```matlab
freq_ranges = {[1,4]; [4,8]; [8,12]; [12,30]; [30,50]; [1,50]};
[features_struct, psd_struct, n] = power_calc(PSD_EEG, features, f3, features_struct, freq_ranges, psd_struct);
```

**Notes**:
- Uses trapezoidal integration to calculate band power
- Power is integral of PSD over frequency range

---

### perc_calc.m
**Purpose**: Calculate relative power percentages for each frequency band

**Syntax**:
```matlab
features_perc = perc_calc(features, PSD_EEG, features_struct)
```

**Inputs**:
- `features` - Array of feature names
- `PSD_EEG` - Power spectral density matrix
- `features_struct` - Structure with absolute band powers

**Outputs**:
- `features_perc` - Structure with relative power percentages (0-1)

**Example**:
```matlab
features_perc = perc_calc(features, PSD_EEG, features_struct);
```

**Notes**:
- Normalizes band powers by dividing by total power
- Useful for sleep stage classification

---

### sample_entropy.m
**Purpose**: Calculate Sample Entropy for signal complexity analysis

**Syntax**:
```matlab
value = sample_entropy(signal, m, r, dist_type)
```

**Inputs**:
- `signal` - Signal vector
- `m` - Embedding dimension (m < N)
- `r` - Tolerance (percentage applied to standard deviation)
- `dist_type` - Distance type (default: 'chebychev')

**Outputs**:
- `value` - Sample Entropy value

**Example**:
```matlab
SampEn = sample_entropy(EEG_epoch, 2, 0.2, 'chebychev');
```

**Notes**:
- Implementation from V. Martínez-Cagigal's HYDRA toolbox
- Returns NaN or upper bound if no regularity detected
- See Richman & Moorman (2000) for details

---

### filtered_sleep_stages_def.m
**Purpose**: Smooth sleep stage transitions using median filtering

**Syntax**:
```matlab
sleep_stage_filtered = filtered_sleep_stages_def(sleep_stage, min_duration)
```

**Inputs**:
- `sleep_stage` - Vector of classified sleep stages (0=Awake, 1=REM, 2=NREM)
- `min_duration` - Number of consecutive epochs for median filtering (typically 6)

**Outputs**:
- `sleep_stage_filtered` - Smoothed sleep stage vector

**Example**:
```matlab
sleep_stage_filtered = filtered_sleep_stages_def(sleep_stage, 6);
```

**Notes**:
- Removes brief transitions between sleep stages
- Uses non-overlapping windows
- 6 epochs = 3 minutes with 30-second epochs

---

### hypnogram.m
**Purpose**: Generate visual hypnogram of sleep stages over time

**Syntax**:
```matlab
t1 = hypnogram(filtered_sleep_stage, epoch_duration)
```

**Inputs**:
- `filtered_sleep_stage` - Vector of sleep stages (0=Awake, 1=REM, 2=NREM)
- `epoch_duration` - Duration of each epoch in seconds

**Outputs**:
- `t1` - Time vector in minutes

**Example**:
```matlab
t1 = hypnogram(filtered_sleep_stage, 30);
```

**Notes**:
- Creates color-coded visualization
- Red = Awake, Light blue = REM, Dark blue = NREM
- Standard tool in sleep medicine

---

## Frequency Bands

The pipeline analyzes the following EEG frequency bands:

| Band | Frequency Range | Associated State |
|------|----------------|------------------|
| **Delta** | 1-4 Hz | Deep sleep (NREM stages 3-4) |
| **Theta** | 4-8 Hz | Light sleep, drowsiness |
| **Alpha** | 8-12 Hz | Relaxed wakefulness, eyes closed |
| **Beta** | 12-30 Hz | Active thinking, alertness |
| **Gamma** | 30-50 Hz | Cognitive processing |
| **Total** | 1-50 Hz | Overall power |

## Sleep Stage Classification Rules

The pipeline uses rule-based classification:

1. **Awake (Stage 0)**:
   - High Alpha activity (> mean + std)
   - High Beta activity (> mean)

2. **REM Sleep (Stage 1)**:
   - Moderate Beta activity (> mean - std)
   - Elevated Theta activity (> mean)

3. **NREM Sleep (Stage 2)**:
   - High Delta activity (> mean - std)

## Usage Example

Complete workflow example:

```matlab
% Add functions to path
addpath('src');

% Configuration
file_name = "data/data.mat";
epoch_duration = 30;
features = ["Delta", "Theta", "Alpha", "Beta", "Gamma", "Total"];
freq_ranges = {[1,4]; [4,8]; [8,12]; [12,30]; [30,50]; [1,50]};

% Load data
[EEG, fs, t] = data_acquisition(file_name);

% Filter
EEG_filtered = double_notch_filter(fs, EEG, t, 1, 2);

% Segment
EEG_seg = eeg_segmentation(fs, EEG_filtered, epoch_duration);

% Calculate PSD
[PSD_EEG, f3] = psd_calc(EEG_seg, fs, 5);

% Extract features
features_struct = struct_def(features);
psd_struct = struct_def(features);
[features_struct, psd_struct, n] = power_calc(PSD_EEG, features, f3, features_struct, freq_ranges, psd_struct);
features_perc = perc_calc(features, PSD_EEG, features_struct);

% Classify and visualize
% ... (see main_pipeline.m for complete classification code)
```

## See Also

- [README.md](README.md) - Main project documentation
- [DATA_FORMAT.md](DATA_FORMAT.md) - Data format specifications
- `main_pipeline.m` - Complete pipeline implementation
