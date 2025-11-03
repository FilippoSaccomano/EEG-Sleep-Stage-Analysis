function [] = plot_eeg_fft(t, EEG, fs)
% PLOT_EEG_FFT Visualize raw EEG signal and its frequency spectrum
%
% Creates a two-panel figure showing the raw EEG signal in the time domain
% and its frequency spectrum using Fast Fourier Transform (FFT).
%
% Inputs:
%   t   - Time vector in seconds (1 x N)
%   EEG - EEG signal amplitude in microvolts (1 x N)
%   fs  - Sampling frequency in Hz (scalar)
%
% Outputs:
%   None (generates figure)
%
% The function creates:
%   - Upper panel: Time-domain signal plot
%   - Lower panel: Frequency spectrum (magnitude)
%
% Example:
%   plot_eeg_fft(t, EEG, 100);
%
% See also: FFT, SUBPLOT

    figure;
    
    % Upper subplot: Time-domain signal
    subplot(211)
    plot(t, EEG)
    xlabel('Time [s]');
    ylabel('Magnitude [\muV]');
    title('Original EEG Signal');
    grid();
    xlim([0, 22000]);  % Limit x-axis for better visualization
    
    % Calculate FFT
    n = length(EEG);
    f = (0:n-1) * (fs / n);  % Frequency vector
    
    EEG_fft = fft(EEG);
    EEG_fft = EEG_fft(1:floor(n/2)+1);  % Keep only positive frequencies
    f = f(1:floor(n/2)+1);
    
    EEG_fft_magnitude = abs(EEG_fft) / n;  % Normalize magnitude
    
    % Lower subplot: Frequency spectrum
    subplot(212)
    plot(f, EEG_fft_magnitude);
    xlabel('Frequency [Hz]');
    grid();
    ylabel('Magnitude [\muV^2/Hz]');
    title('FFT of EEG Signal');
end
