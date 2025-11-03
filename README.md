# EEG Sleep Stage Analysis Pipeline

An automated MATLAB pipeline for processing and classifying EEG sleep stages using spectral analysis and entropy metrics.

## Overview

This project implements an automated system for analyzing EEG (electroencephalogram) signals to classify sleep stages. The pipeline processes raw EEG data through filtering, segmentation, feature extraction, and classification to generate a hypnogram showing the progression of sleep stages over time.

### Sleep Stages Detected

- **Awake**: Characterized by high alpha and beta wave activity
- **REM Sleep**: Rapid Eye Movement sleep with theta and beta wave patterns
- **NREM Sleep**: Non-Rapid Eye Movement sleep with dominant delta wave activity

## Features

- **Signal Preprocessing**: Double notch filtering to remove 1Hz and 2Hz noise artifacts
- **Epoch Segmentation**: Automatic division of continuous EEG into 30-second epochs
- **Spectral Analysis**: Power spectral density (PSD) calculation for each epoch
- **Feature Extraction**: 
  - Frequency band power (Delta, Theta, Alpha, Beta, Gamma)
  - Relative power percentages
  - Sample Entropy (SampEn) for complexity analysis
  - Approximate Entropy (ApEn) for regularity assessment
- **Sleep Stage Classification**: Rule-based classification using spectral features
- **Hypnogram Generation**: Visual representation of sleep stage progression
- **Results Visualization**: Comprehensive plots including FFT, PSD, and hypnograms

## Repository Structure

```
EEG-Sleep-Stage-Analysis/
├── README.md                 # This file - project overview and documentation
├── DATA_FORMAT.md           # Data requirements and sources
├── main_pipeline.m          # Main pipeline script (run everything)
├── original_analysis.mlx    # Original analysis notebook (reference)
├── data/
│   └── data.mat             # Example data (not included - see DATA_FORMAT.md)
└── src/                     # MATLAB function library
    ├── data_acquisition.m           # Load EEG data from .mat file
    ├── plot_eeg_fft.m              # Visualize raw signal and FFT
    ├── double_notch_filter.m       # Remove 1Hz and 2Hz noise
    ├── eeg_segmentation.m          # Divide signal into epochs
    ├── psd_calc.m                  # Calculate power spectral density
    ├── struct_def.m                # Initialize feature structures
    ├── power_calc.m                # Calculate band power features
    ├── perc_calc.m                 # Calculate relative power percentages
    ├── sample_entropy.m            # Calculate sample entropy
    ├── filtered_sleep_stages_def.m # Smooth sleep stage transitions
    └── hypnogram.m                 # Generate hypnogram visualization
```

## Quick Start

### Prerequisites

- MATLAB R2019b or later
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox (for entropy functions)

### Installation

1. Clone this repository:
```bash
git clone https://github.com/FilippoSaccomano/EEG-Sleep-Stage-Analysis.git
cd EEG-Sleep-Stage-Analysis
```

2. Prepare your data file following the format in [DATA_FORMAT.md](DATA_FORMAT.md) and place it in the `data/` directory

### Usage

#### Option 1: Run the Complete Pipeline (Recommended)

Open MATLAB and run the main pipeline:
```matlab
% Run the main pipeline script
main_pipeline
```

Or open the script in the MATLAB editor:
```matlab
open('main_pipeline.m')
% Then click "Run" in MATLAB Editor
```

#### Option 2: Run Step by Step

```matlab
% Add functions to path
addpath('src');

% Set parameters
file_name = "data/data.mat";
epoch_duration = 30;  % seconds

% Run the pipeline (see main_pipeline.m for complete code)
[EEG, fs, t] = data_acquisition(file_name);
% ... (continue with other steps)
```

## Pipeline Steps

### 1. Data Acquisition
Loads EEG signal and sampling frequency from .mat file.

### 2. Signal Visualization
Plots raw EEG signal in time and frequency domains.

### 3. Noise Filtering
Applies double notch filter to remove 1Hz and 2Hz noise components.

### 4. Epoch Segmentation
Divides the continuous signal into 30-second epochs for analysis.

### 5. Power Spectral Density Calculation
Computes PSD for each epoch using Welch's method with Hamming windows.

### 6. Feature Extraction
Calculates power in frequency bands:
- **Delta** (1-4 Hz): Deep sleep indicator
- **Theta** (4-8 Hz): Light sleep and REM
- **Alpha** (8-12 Hz): Relaxed wakefulness
- **Beta** (12-30 Hz): Active wakefulness
- **Gamma** (30-50 Hz): Cognitive processing

### 7. Entropy Analysis
- **Sample Entropy**: Measures signal complexity
- **Approximate Entropy**: Quantifies signal regularity

### 8. Sleep Stage Classification
Uses spectral power ratios and statistical thresholds to classify each epoch:
- High Alpha + Beta → Awake
- High Delta → NREM Sleep
- Moderate Beta + Theta → REM Sleep

### 9. Hypnogram Generation
Creates visual timeline of sleep stages with smoothing to remove brief transitions.

## Output

The pipeline generates several figures:
1. Raw EEG signal and its FFT
2. Filtered EEG signal (noise removed)
3. Frequency responses of notch filters
4. Average PSD across all epochs
5. Hypnogram showing sleep stage progression
6. Combined hypnogram with Sample Entropy overlay

## Configuration Parameters

Key parameters you can adjust in `main_pipeline.m`:

```matlab
file_name = "data/data.mat";  % Path to your data file
epoch_duration = 30;          % Epoch length in seconds
window_dim = 5;               % PSD window dimension
min_duration = 6;             % Minimum epochs for stage smoothing
m = 2;                        % Entropy embedding dimension
r = 0.2;                      % Entropy tolerance
```

## Data Requirements

This pipeline requires EEG sleep data in a specific MATLAB format. Since the original `.dat` files are private/proprietary, you need to provide your own data.

**See [DATA_FORMAT.md](DATA_FORMAT.md) for detailed information on:**
- Required data structure
- Where to obtain public EEG sleep datasets
- How to convert data to the required format
- Data quality requirements

## Scientific Background

This pipeline is based on established sleep stage classification methods using EEG spectral analysis. The approach combines:

1. **Linear Analysis**: Power spectral density in standard EEG frequency bands
2. **Non-linear Analysis**: Entropy metrics (Sample Entropy, Approximate Entropy)
3. **Rule-based Classification**: Statistical thresholds based on spectral features

### Key References

The methods implemented in this pipeline are based on the following scientific papers:

1. **Huang, C. S., Lin, C. L., Ko, L. W., Liu, S. Y., Su, T. P., & Lin, C. T. (2014)**. 
   *"Knowledge-based identification of sleep stages based on two forehead electroencephalogram channels."*
   Frontiers in Neuroscience, 8, 263.
   DOI: 10.3389/fnins.2014.00263
   - This paper describes methods for automated sleep stage classification using limited EEG channels
   - Implements spectral analysis and machine learning approaches

2. **Rechtschaffen, A., & Kales, A. (1968)**.
   *"A manual of standardized terminology, techniques and scoring system for sleep stages of human subjects."*
   NIH Publication, 204.
   - The classic reference for sleep stage scoring (R&K criteria)
   - Defines standard sleep stages and scoring rules
   - Foundation for modern sleep analysis

Additional relevant references:
- **Richman, J. S., & Moorman, J. R. (2000)**. Physiological time-series analysis using approximate entropy and sample entropy. *American Journal of Physiology-Heart and Circulatory Physiology*, 278(6), H2039-H2049.
  - Describes Sample Entropy calculation (implemented in `sample_entropy.m`)

## Function Documentation

### Core Functions

#### `data_acquisition(file_name)`
Loads EEG data from .mat file.
- **Input**: `file_name` - path to .mat file
- **Output**: `EEG` - signal vector, `fs` - sampling frequency, `t` - time vector

#### `double_notch_filter(fs, EEG, t, Fcut1, Fcut2)`
Applies two notch filters to remove specific frequency noise.
- **Inputs**: sampling frequency, EEG signal, time vector, cutoff frequencies
- **Output**: filtered EEG signal
- **Plots**: Filter frequency responses and filtered signal

#### `eeg_segmentation(fs, EEG, epoch_duration)`
Divides continuous EEG into fixed-duration epochs.
- **Inputs**: sampling frequency, EEG signal, epoch duration (seconds)
- **Output**: Matrix of EEG segments (epochs × samples)

#### `psd_calc(EEG_seg, fs, window_dim)`
Calculates power spectral density using Welch's method.
- **Inputs**: segmented EEG, sampling frequency, window dimension
- **Output**: PSD matrix (epochs × frequencies), frequency vector
- **Plots**: Average PSD across epochs

#### `power_calc(PSD_EEG, features, f3, features_struct, freq_ranges, psd_struct)`
Computes power in specified frequency bands.
- **Inputs**: PSD matrix, feature names, frequencies, structures, frequency ranges
- **Output**: Updated structures with band powers

#### `sample_entropy(signal, m, r, dist_type)`
Calculates Sample Entropy for signal complexity analysis.
- **Inputs**: signal vector, embedding dimension, tolerance, distance type
- **Output**: Sample Entropy value

#### `hypnogram(filtered_sleep_stage, epoch_duration)`
Generates visual hypnogram of sleep stages.
- **Inputs**: sleep stage vector, epoch duration
- **Output**: time vector
- **Plots**: Color-coded hypnogram

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Author

Filippo Saccomano

## Acknowledgments

- Sample Entropy implementation adapted from V. Martínez-Cagigal's HYDRA toolbox
- Based on established sleep analysis methods from sleep research literature
- Inspired by standard polysomnography analysis techniques

---

**Note**: This pipeline is for research and educational purposes. It is not intended for clinical diagnosis or medical use.
