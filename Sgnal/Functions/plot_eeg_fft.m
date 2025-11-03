function [] = plot_eeg_fft(t, EEG, fs)
figure;
subplot(211)
plot(t, EEG)
xlabel('Time [s]');
ylabel('Magnitude [\muV]');
title('Original EEG Signal');
grid();
xlim([0, 22000]);

n = length(EEG);
f = (0:n-1)*(fs/n);

EEG_fft = fft(EEG);
EEG_fft = EEG_fft(1:floor(n/2)+1);
f = f(1:floor(n/2)+1);

EEG_fft_magnitude = abs(EEG_fft) / n;

subplot(212)
plot(f, EEG_fft_magnitude);
xlabel('Frequency [Hz]');
grid();
ylabel('Magnitude [\muV^2/Hz]');
title('FFT of EEG Signal');
end
