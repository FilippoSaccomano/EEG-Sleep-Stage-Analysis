function [EEG, fs, t] = data_acquisition(file_name)
% DATA_ACQUISITION Load EEG data from .mat file
%
% Loads EEG sleep data from a MATLAB .mat file containing a 'dati' struct
% with EEG signal and sampling frequency information.
%
% Inputs:
%   file_name - String path to .mat file (e.g., "data.mat")
%
% Outputs:
%   EEG - EEG signal vector (1 x N samples) in microvolts
%   fs  - Sampling frequency in Hz (scalar)
%   t   - Time vector in seconds (1 x N samples)
%
% Example:
%   [EEG, fs, t] = data_acquisition("data.mat");
%
% Required data structure in .mat file:
%   dati.eeg - EEG signal data
%   dati.fs  - Sampling frequency
%
% See also: LOAD

    % Load data from .mat file
    data = load(file_name);
    
    % Extract EEG signal and sampling frequency from structure
    EEG = data.dati.eeg;
    fs = data.dati.fs;
    
    % Create time vector from 0 to signal duration
    t = [0:length(EEG)-1] / fs;
end