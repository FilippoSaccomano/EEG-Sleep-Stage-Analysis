function [EEG_filtered] = double_notch_filter(fs, EEG, t, Fcut1, Fcut2)
% DOUBLE_NOTCH_FILTER Apply two notch filters to remove specific frequency noise
%
% Removes narrow-band noise at two specified frequencies using IIR notch
% filters. Commonly used to remove 1Hz and 2Hz artifacts from EEG signals.
% Also generates visualization of filter responses and filtered signal.
%
% Inputs:
%   fs    - Sampling frequency in Hz (scalar)
%   EEG   - Raw EEG signal vector (1 x N samples)
%   t     - Time vector in seconds (1 x N)
%   Fcut1 - First cutoff frequency in Hz (typically 1 Hz)
%   Fcut2 - Second cutoff frequency in Hz (typically 2 Hz)
%
% Outputs:
%   EEG_filtered - Filtered EEG signal vector (1 x N samples)
%
% The function also generates three figures:
%   1. Frequency response of first notch filter
%   2. Frequency response of second notch filter
%   3. Filtered signal (time domain) and its FFT
%
% Example:
%   EEG_filtered = double_notch_filter(100, EEG, t, 1, 2);
%
% See also: DESIGNNOTCHPEAKIIR, FILTFILT, FFT

    % Remove linear trend from signal
    EEG = detrend(EEG);
    
    % Quality factor for notch filters (higher = narrower notch)
    Q = 90;
    
    % Normalize cutoff frequencies to Nyquist frequency
    Wo1 = Fcut1 / (fs / 2);
    Wo2 = Fcut2 / (fs / 2);
    
    % Design first notch filter (e.g., 1 Hz)
    [B_1hz, A_1hz] = designNotchPeakIIR('Response', 'notch', ...
                                        'CenterFrequency', Wo1, ...
                                        'Bandwidth', Wo1/Q, ...
                                        'FilterOrder', 2);
    
    % Design second notch filter (e.g., 2 Hz)
    [B_2hz, A_2hz] = designNotchPeakIIR('Response', 'notch', ...
                                        'CenterFrequency', Wo2, ...
                                        'Bandwidth', Wo2/Q, ...
                                        'FilterOrder', 2);
    
    % Plot frequency response of first filter
    figure;
    freqz(B_1hz, A_1hz)
    title("Frequency Response of 1Hz Notch Filter")
    
    % Plot frequency response of second filter
    figure;
    freqz(B_2hz, A_2hz)
    title("Frequency Response of 2Hz Notch Filter")
    
    % Apply filters using zero-phase filtering (filtfilt)
    EEG_filtered = filtfilt(B_1hz, A_1hz, EEG);
    EEG_filtered = filtfilt(B_2hz, A_2hz, EEG_filtered);
    
    % Visualize filtered signal
    figure;
    subplot(211), plot(t, EEG_filtered);
    title('Noise Removed from EEG Signal');
    xlim([0, max(t)]);
    xlabel('Time [s]');
    ylabel('Amplitude');
    
    % Compute and plot FFT of filtered signal
    n = length(EEG_filtered);
    EEG_fft = fft(EEG_filtered);
    f = (0:n-1) * (fs / n);
    
    % Keep only positive frequencies
    EEG_fft = EEG_fft(1:floor(n/2)+1);
    f = f(1:floor(n/2)+1);
    
    EEG_fft_magnitude = abs(EEG_fft) / n;
    
    subplot(212);
    plot(f, EEG_fft_magnitude);
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [\muV]');
    title('FFT of EEG Filtered Signal');
    grid on;
end
