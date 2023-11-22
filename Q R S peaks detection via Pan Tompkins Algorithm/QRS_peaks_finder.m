function [peaks, locations] = QRS_peaks_finder(ECG, Fs, plot_option)
%first vector of the outputs are related to the Q wave, 2nd to the R & 3rd to the S

ECG3 = transpose(load('ECG3.dat'));     ECG3 = ECG3/max(ECG3);
ECG4 = transpose(load('ECG4.dat'));     ECG4 = ECG4/max(ECG4);
ECG5 = transpose(load('ECG5.dat'));     ECG5 = ECG5/max(ECG5);
ECG6 = transpose(load('ECG6.dat'));     ECG6 = ECG6/max(ECG6);

switch num2str(ECG)
    case num2str(ECG3)
        n = 3;
    case num2str(ECG4)
        n = 4;
    case num2str(ECG5)
        n = 5;
    case num2str(ECG6)
        n = 6;        
end

[B2, A2] = butter(3,4*2/Fs, "high");
ECG = fliplr(filter(B2, A2, fliplr(filter(B2, A2, ECG))));

[b, a] = butter(7,4*2/Fs,'high');
filtered_ECG = fliplr(filter(b, a, fliplr(filter(b, a, ECG))));

R_pan_tomp = pan_tomp(ECG,Fs ,50, 0);
pks = findpeaks(R_pan_tomp);
[~, locs] = findpeaks(R_pan_tomp,"MinPeakHeight",sum(pks)/length(pks)-0.2);

if locs(length(locs))+0.08*Fs>length(ECG)
    locs(length(locs)) = [];
end
peaks      = zeros(3,length(locs));
locations = zeros(3,length(locs));
peaks(2,:) = abs(ECG(locs));
locations(2,:) = locs/Fs;
for i = 1:length(locs)
    if locs(i)+0.08*Fs>length(ECG)
        endx = length(ECG); 
    else 
        endx = locs(i)+0.08*Fs;
    end
    wind_f = -filtered_ECG(locs(i)-0.08*Fs:endx);
    wind = -ECG(locs(i)-0.08*Fs:endx);
    p_f = findpeaks(wind,"MinPeakDistance",9,"NPeaks",2);
    [~,l] = findpeaks(wind_f,"MinPeakDistance",9,"NPeaks",2);
    peaks(1,i)  =  -p_f(1);
    peaks(3,i)  = -p_f(2);
    locations(1,i) = l(1) + locs(i) - 17;
    locations(3,i) = l(2) + locs(i) - 18;
end
locations(1,:) = locations(1,:)/Fs;
locations(3,:) = locations(3,:)/Fs;

if plot_option == 1
    t = linspace(0, length(ECG)/Fs, length(ECG));
    figure(Name = ['Output for ECG',num2str(n)])
    plot(t,ECG),       hold on
    plot(locations(1,:),peaks(1,:),'Linestyle','none','Marker','x','LineWidth',3),     hold on
    plot(locations(2,:),peaks(2,:),'Linestyle','none','Marker','o','LineWidth',3),     hold on
    plot(locations(3,:),peaks(3,:),'Linestyle','none','Marker','+','LineWidth',3),     hold on
    title(['ECG and All QRS complexes for data number ',num2str(n)]),       xlabel('Time(seconds)'),         ylabel('Normalized Amplitute')
    legend('ECG','Q peaks','R peaks','S peaks')
end
end