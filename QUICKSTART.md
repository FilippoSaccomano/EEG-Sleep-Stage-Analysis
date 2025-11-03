# Quick Start Guide

Get started with EEG Sleep Stage Analysis in 5 minutes!

## Prerequisites

Before you begin, ensure you have:
- [ ] MATLAB R2019b or later installed
- [ ] Signal Processing Toolbox
- [ ] Statistics and Machine Learning Toolbox

## Step 1: Clone the Repository

```bash
git clone https://github.com/FilippoSaccomano/EEG-Sleep-Stage-Analysis.git
cd EEG-Sleep-Stage-Analysis
```

## Step 2: Prepare Your Data

You need EEG sleep data in MATLAB `.mat` format. 

### Option A: Use Public Data

Download from PhysioNet Sleep-EDF Database:
1. Go to https://physionet.org/content/sleep-edf/1.0.0/
2. Download an EDF file (e.g., `SC4001E0-PSG.edf`)
3. Convert to .mat format in MATLAB:

```matlab
% Read EDF file
[data, annotations, fs] = edfread('SC4001E0-PSG.edf');

% Extract EEG channel (adjust channel name as needed)
eeg_channel = table2array(data(:, 'EEG Fpz-Cz'));  % or appropriate channel

% Create the required structure
dati.eeg = double(eeg_channel)';  % Convert to row vector
dati.fs = fs;

% Save to data directory
save('data/data.mat', 'dati');
```

### Option B: Use Your Own Data

Create a .mat file with this structure:
```matlab
dati.eeg = [your_eeg_signal];  % Row vector of EEG values in μV
dati.fs = [sampling_frequency];  % Sampling frequency in Hz

save('data/data.mat', 'dati');
```

See [DATA_FORMAT.md](DATA_FORMAT.md) for detailed requirements.

## Step 3: Run the Analysis

Open MATLAB and run:

```matlab
% Navigate to the repository directory
cd /path/to/EEG-Sleep-Stage-Analysis

% Run the complete pipeline
main_pipeline
```

That's it! The script will:
1. Load your data
2. Filter the signal
3. Extract features
4. Classify sleep stages
5. Generate visualizations

## Expected Output

You'll see several figures:
1. **Raw EEG Signal and FFT** - Shows original signal in time and frequency domains
2. **Notch Filter Responses** - Frequency response of 1Hz and 2Hz filters
3. **Filtered Signal and FFT** - Shows cleaned signal after filtering
4. **Mean PSD** - Average power spectral density across all epochs
5. **Hypnogram** - Color-coded sleep stage progression over time
6. **Hypnogram vs Sample Entropy** - Combined visualization with complexity metric

Plus console output with statistics:
```
========== ANALYSIS COMPLETE ==========
Total recording duration: 480.0 minutes
Number of epochs analyzed: 960

Sleep Stage Distribution:
  Awake: 15.2%
  REM:   23.8%
  NREM:  61.0%

Execution time: 45.23 seconds
======================================
```

## Troubleshooting

### "File not found" error
- Ensure `data/data.mat` exists
- Check file path in `main_pipeline.m` line 47

### "Undefined function or variable 'dati'"
- Your .mat file must contain a struct named `dati`
- Check with: `load('data/data.mat'); whos`

### "Not enough input arguments"
- Make sure all functions in `src/` are accessible
- The script adds `src` to path automatically

### Figures look wrong
- Check that your sampling frequency is correct
- Ensure data is in microvolts (μV)
- Verify data is a row vector, not column

### Poor classification results
- Signal might be too short (need at least 2-3 hours)
- Data quality issues (artifacts, noise)
- Adjust classification thresholds in main_pipeline.m

## Next Steps

- Review [README.md](README.md) for detailed documentation
- Check [FUNCTIONS.md](FUNCTIONS.md) for function reference
- Modify parameters in `main_pipeline.m` to tune classification
- Explore `original_analysis.mlx` for the original workflow

## Need Help?

- Read the full documentation in README.md
- Check DATA_FORMAT.md for data requirements
- Review FUNCTIONS.md for detailed function descriptions
- Open an issue on GitHub for bug reports or questions

## Example Datasets

Recommended datasets to try:
1. **Sleep-EDF Database**: https://physionet.org/content/sleep-edf/1.0.0/
2. **Sleep-EDF Expanded**: https://physionet.org/content/sleep-edfx/1.0.0/
3. **CAP Sleep Database**: https://physionet.org/content/capslpdb/1.0.0/

---

Happy analyzing! 🧠💤
