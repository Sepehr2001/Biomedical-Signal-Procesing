function out = QRS_intervals(ECG, Fs)

[~ , locs] = QRS_peaks_finder(ECG,Fs, 0);
sum = zeros(1,length(locs(1,:)));
for i =1:length(locs(2,:)) - 1
    sum(i) = locs(3,i) - locs(1,i);  % in seconds
end
out = sum;
end
