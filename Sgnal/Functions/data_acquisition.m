function [EEG, fs, t] = data_acquisition(file_name)

data= load(file_name);
EEG=data.dati.eeg;
fs=data.dati.fs;
t=[0:length(EEG)-1]/fs;

end