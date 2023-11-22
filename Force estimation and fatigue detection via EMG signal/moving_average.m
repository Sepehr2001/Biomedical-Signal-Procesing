function [t, out] = moving_average(EMG, Fs, window_duration, pad_size)
    
padded_EMG = padarray(EMG, [0 pad_size],'replicate');

windowSize = window_duration / 1000 * Fs; 
padded_EMG = padded_EMG.^2;
B4 = (1/windowSize)*ones(1,windowSize);
out = fliplr(filter(B4, 1, fliplr(filter(B4, 1, padded_EMG))));
out = out(pad_size+1:length(out)-pad_size);
t = linspace(0, length(out)/Fs, length(out));

end