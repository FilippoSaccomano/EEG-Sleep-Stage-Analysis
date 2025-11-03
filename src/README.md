# Source Functions

This directory contains all MATLAB functions used in the EEG Sleep Stage Analysis pipeline.

## Function Categories

### Data Loading and Visualization
- `data_acquisition.m` - Load EEG data from .mat file
- `plot_eeg_fft.m` - Visualize raw signal and FFT

### Signal Processing
- `double_notch_filter.m` - Remove 1Hz and 2Hz noise
- `eeg_segmentation.m` - Divide signal into epochs

### Feature Extraction
- `psd_calc.m` - Calculate power spectral density
- `power_calc.m` - Calculate band power features
- `perc_calc.m` - Calculate relative power percentages
- `sample_entropy.m` - Calculate sample entropy

### Sleep Stage Analysis
- `filtered_sleep_stages_def.m` - Smooth sleep stage transitions
- `hypnogram.m` - Generate hypnogram visualization

### Utilities
- `struct_def.m` - Initialize feature structures

## Usage

Add this directory to your MATLAB path:
```matlab
addpath('src');
```

For detailed function documentation, see [FUNCTIONS.md](../FUNCTIONS.md).
