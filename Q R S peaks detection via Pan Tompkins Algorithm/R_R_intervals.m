function out = R_R_intervals(ECG, Fs)

[~ , locs] = QRS_peaks_finder(ECG,Fs, 0);
sum = zeros(1,length(locs(2,:)));
for i =1:length(locs(2,:)) - 1
    sum(i) = locs(2,i+1) - locs(2,i);       % in seconds
end
sum(length(locs(2,:))) = [];
out = sum;
end