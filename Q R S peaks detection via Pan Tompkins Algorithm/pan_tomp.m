function [out] = pan_tomp(ECG, Fs, pad_size, plot_option) 

t = linspace(0, length(ECG)/Fs, length(ECG));
n=3;
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

%padding before filtering

padded_ECG = padarray(ECG, [0 pad_size],'replicate');
t_padded = padarray(t, [0 pad_size],'replicate');
% Low-pass Filter

fn_low = 15;
[B1, A1] = butter(3, fn_low*2/Fs, "low");
ecg_lp = fliplr(filter(B1, A1, fliplr(filter(B1, A1, padded_ECG))));

%Highpass filter
fn_high = 5;
[B2, A2] = butter(3,fn_high*2/Fs, "high");
ecg_hp = fliplr(filter(B2, A2, fliplr(filter(B2, A2, ecg_lp))));

%Derivative filter: from (4.14) eq 
B3 = [2 1 0 -1 -2]/8;
ecg_df = fliplr(filter(B3, 1, fliplr(filter(B3, 1, ecg_hp))));

%Squaring
ecg_sq = ecg_df .^2;

%Integration: from (4.15) eq 
windowSize = 30; 
B4 = (1/windowSize)*ones(1,windowSize);
out = fliplr(filter(B4, 1, fliplr(filter(B4, 1, ecg_sq))));
out = out(pad_size+1:length(out)-pad_size);
out = out/max(out);

if plot_option == 1
    figure(Name=['Pan Tompkin step by step! for ECG',num2str(n)])
    subplot(321),       plot(t, ECG),           title('Main ECG')
    subplot(322),       plot(t_padded, ecg_lp),       title('Low Passed')
    subplot(323),       plot(t_padded, ecg_hp),      title('High Passed')
    subplot(324),       plot(t_padded, ecg_df),      title('Deivated')
    subplot(325),       plot(t_padded, ecg_sq),      title('Squared')
    subplot(326),       plot(t, out),            title('Integrated(final result)')
end
end
