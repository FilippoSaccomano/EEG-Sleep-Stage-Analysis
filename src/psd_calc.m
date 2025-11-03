function [PSD_EEG, f3] = psd_calc(EEG_seg, fs, window_dim)
% PSD_CALC Calculate Power Spectral Density for each EEG epoch
%
% Computes the Power Spectral Density (PSD) for each epoch using Welch's
% method with Hamming windows. This provides frequency domain representation
% of each epoch, essential for extracting spectral features.
%
% Inputs:
%   EEG_seg    - Matrix of EEG epochs (n_epochs x samples_per_epoch)
%   fs         - Sampling frequency in Hz (scalar)
%   window_dim - Window duration in seconds for Welch's method (typically 5)
%
% Outputs:
%   PSD_EEG - Power spectral density matrix (n_epochs x n_frequencies)
%             Each row contains PSD values for one epoch
%   f3      - Frequency vector in Hz (1 x n_frequencies)
%
% The function also generates a figure showing the mean PSD across all epochs.
%
% Example:
%   [PSD_EEG, f3] = psd_calc(EEG_seg, 100, 5);
%
% Method:
%   - Uses pwelch() with Hamming windows
%   - 50% overlap between windows
%   - 1024-point FFT
%
% See also: PWELCH, HAMMING

    % 50% overlap for Welch's method
    noverlap = 100 / 2;
    
    % Pre-allocate PSD matrix
    PSD_EEG = [];
    
    % Calculate PSD for each epoch
    for i = 1:size(EEG_seg, 1)
        % Welch's method: estimates PSD using averaged periodograms
        [PSDw_3, f3] = pwelch(EEG_seg(i,:), ...           % Signal
                              hamming(fs*window_dim), ... % Window
                              noverlap, ...               % Overlap
                              1024, ...                   % FFT points
                              fs);                        % Sampling freq
        
        % Concatenate PSD for this epoch
        PSD_EEG = [PSD_EEG, PSDw_3];
    end
    
    % Transpose to have epochs as rows
    PSD_EEG = transpose(PSD_EEG);
    
    % Calculate average PSD across all epochs
    PSD_EEG_tot = mean(PSD_EEG, 1);
    
    % Plot average PSD
    figure;
    plot(f3, PSD_EEG_tot)
    title("PSD MEAN EPOCH")
    xlabel('Frequency [Hz]')
    ylabel('Power Spectral Density [\muV^2/Hz]')
    grid on
end