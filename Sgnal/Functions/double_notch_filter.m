function [EEG_filtered] = double_notch_filter(fs, EEG, t, Fcut1, Fcut2)

EEG = detrend(EEG);
Q = 90;

Wo1 = Fcut1 / (fs / 2);
Wo2 = Fcut2 / (fs / 2);

[B_1hz, A_1hz] = designNotchPeakIIR('Response', 'notch', 'CenterFrequency', Wo1, 'Bandwidth', Wo1/Q, 'FilterOrder', 2);
[B_2hz, A_2hz] = designNotchPeakIIR('Response', 'notch', 'CenterFrequency', Wo2, 'Bandwidth', Wo2/Q, 'FilterOrder', 2);

figure;
freqz(B_1hz, A_1hz)
title("Frequency Response of 1Hz Notch Filter")
figure;
freqz(B_2hz, A_2hz)
title("Frequency Response of 2Hz Notch Filter")

EEG_filtered = filtfilt(B_1hz, A_1hz, EEG);
EEG_filtered = filtfilt(B_2hz, A_2hz, EEG_filtered);

figure;
subplot(211), plot(t, EEG_filtered);
title('Noise Removed from EEG Signal');
xlim([0, max(t)]);
xlabel('Time [s]');
ylabel('Amplitude');

n = length(EEG_filtered);
EEG_fft = fft(EEG_filtered);
f = (0:n-1) * (fs / n);

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
