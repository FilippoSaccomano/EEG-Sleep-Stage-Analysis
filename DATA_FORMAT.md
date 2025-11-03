# Data Format Requirements

## Required Data Structure

This pipeline requires EEG sleep data in MATLAB `.mat` format with a specific structure.

### Data Format Specification

The input file (e.g., `data.mat`) must contain a struct named `dati` with the following fields:

```matlab
dati
├── eeg     % EEG signal data (vector of double values)
├── fs      % Sampling frequency in Hz (scalar, typically 100-500 Hz)
└── ...     % Optional: other metadata fields
```

### Field Descriptions

1. **`dati.eeg`**: 
   - Type: Double array (1 x N samples)
   - Description: Raw EEG signal amplitude values in microvolts (μV)
   - Requirements: Continuous single-channel EEG recording
   
2. **`dati.fs`**: 
   - Type: Scalar double
   - Description: Sampling frequency in Hertz (Hz)
   - Typical values: 100 Hz, 128 Hz, 200 Hz, 256 Hz, or 500 Hz
   - Recommended: At least 100 Hz for proper frequency analysis

### Data Sources

You can obtain compatible EEG sleep data from the following public databases:

#### 1. PhysioNet Sleep Databases
- **Sleep-EDF Database**: https://physionet.org/content/sleep-edf/1.0.0/
  - Contains polysomnographic sleep recordings
  - Format: EDF (can be converted to .mat using MATLAB's edfread)
  
- **Sleep-EDF Database Expanded**: https://physionet.org/content/sleep-edfx/1.0.0/
  - Larger dataset with more subjects
  - Format: EDF files

#### 2. DREAMS Database
- **DREAMS Subjects Database**: http://www.tcts.fpms.ac.be/~devuyst/Databases/DatabaseSubjects/
  - Contains EEG recordings with expert annotations
  - Includes metadata about sleep stages

#### 3. CAP Sleep Database
- **Cyclic Alternating Pattern Database**: https://physionet.org/content/capslpdb/1.0.0/
  - Contains polysomnographic recordings
  - Format: EDF

### Data Conversion

If you have EDF format data, convert it to the required .mat format using MATLAB:

```matlab
% Read EDF file
[eeg_signal, annotations, fs] = edfread('your_file.edf');

% Extract EEG channel (adjust channel name as needed)
eeg_channel = eeg_signal.C3_A2;  % or appropriate channel name

% Create the required structure
dati.eeg = double(eeg_channel);  % Convert to double array
dati.fs = fs;

% Save to .mat file
save('data.mat', 'dati');
```

### Data Quality Requirements

For optimal results, ensure your data meets these criteria:

1. **Duration**: At least 4-8 hours of continuous recording (typical sleep study)
2. **Sampling Rate**: Minimum 100 Hz (higher is better for detailed frequency analysis)
3. **Signal Quality**: 
   - Minimal artifacts
   - Stable baseline
   - Good signal-to-noise ratio
4. **Channel**: Single EEG channel (typically C3-A2, C4-A1, or similar)

### Example Data Structure

```matlab
>> load('data.mat')
>> whos dati
  Name        Size            Bytes  Class     Attributes
  dati        1x1              ...    struct              

>> fieldnames(dati)
ans =
    'eeg'
    'fs'

>> size(dati.eeg)
ans =
     1   3600000    % Example: 10 hours at 100 Hz

>> dati.fs
ans =
   100             % 100 Hz sampling rate
```

### Notes

- The pipeline expects 30-second epochs for sleep stage classification
- Ensure your recording is long enough to capture multiple sleep cycles
- The data should be pre-processed (filtered) by the pipeline, no manual preprocessing needed
- Keep the original data backed up before running the analysis
