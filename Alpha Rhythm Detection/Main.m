clc
clear all;
close all;

c3 = transpose(load("eeg1-c3.dat"));
c4 = transpose(load("eeg1-c4.dat"));
f3 = transpose(load("eeg1-f3.dat"));
f4 = transpose(load("eeg1-f4.dat"));
o1 = transpose(load("eeg1-o1.dat"));
o2 = transpose(load("eeg1-o2.dat"));
p3 = transpose(load("eeg1-p3.dat"));
p4 = transpose(load("eeg1-p4.dat"));

Fs = 100;         %sampling frequency

%P4 = my_fft(p4);

%% let's plot all channels first

t = linspace(0,length(c3)/Fs,length(c3));        %Fs = 100 & signal length is 750 so time interval is 0 to 7.5 sec
figure(Name='All Channels in time domain')
subplot(421);       plot(t,c3);       title('eeg1-c3(t)','FontSize',13);        xlim([0 7.5]);
subplot(422);       plot(t,c4);       title('eeg1-c4(t)','FontSize',13);        xlim([0 7.5]);
subplot(423);       plot(t,f3);       title('eeg1-f3(t)','FontSize',13);        xlim([0 7.5]);
subplot(424);       plot(t,f4);       title('eeg1-f4(t)','FontSize',13);        xlim([0 7.5]);
subplot(425);       plot(t,o1);       title('eeg1-o1(t)','FontSize',13);         xlim([0 7.5]);
subplot(426);       plot(t,o2);       title('eeg1-o2(t)','FontSize',13);        xlim([0 7.5]);
subplot(427);       plot(t,p3);       title('eeg1-p3(t)','FontSize',13);        xlim([0 7.5]);        xlabel('time (sec)');
subplot(428);       plot(t,p4);       title('eeg1-p4(t)','FontSize',13);        xlim([0 7.5]);        xlabel('time (sec)');


%% Now let's extract the alpha rhythm and check its power spectrum

my_alpha = p3(round(4.9*Fs) : round(5.7*Fs));  % I think alpha wave is clear 
alpha_time = t(round(4.9*Fs) : round(5.7*Fs));  % in channel p3 from 4.9 to 5.6 sec

%method 1 for checking the power spectrum:
h=spectrum.welch;

figure(Name='Extracted Alpha wave and its psd')
subplot(211);      plot(alpha_time,  my_alpha);     title('Alpha wave extracted from channel p3');    xlabel('time(sec)');
subplot(212);      psd(h,my_alpha, 'fs', Fs);         title('Welch power spectrum');                             xlabel('f (Hz)');

%method 2 for checking the power spectrum:
alpha_auto = autocorr(my_alpha);
[fa, aa] = my_fft(alpha_auto, Fs);

%method 3 for checking the power spectrum:
[alpha_x,b] = xcorr(my_alpha);
alpha_x = alpha_x./max(alpha_x);
[fx, ax] = my_fft(alpha_x, Fs);

figure(Name='Alpha rhythm psd with autocorrelation')
subplot(221);      plot(alpha_auto);   title('Autocorrelation of Alpha wave(Autocorr method)');  xlabel('time(sec)')
subplot(222);      plot(fa, aa);           title('Autocorr fft : Power Spectrum');        xlabel('f (Hz)');
subplot(223);      plot(b, alpha_x);    title('Autocorrelation of Alpha wave(xcorr method)');       xlabel('delay time')
subplot(224);      plot(fx, ax);           title('xcorr fft : Power Spectrum');             xlabel('f (Hz)');

%% Now It's time for Alpha pattern matching in every channel

scaled_alpha = zeros(1,length(t));
scaled_alpha(round(4.9*Fs) : round(5.7*Fs)) = my_alpha;

figure(Name='Channel c3 pattern matching')
c3_cor = my_pattern_match(c3, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,c3);                              title('eeg1-c3(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,c3_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel c4 pattern matching')
c4_cor = my_pattern_match(c4, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,c4);                              title('eeg1-c4(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,c4_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel f3 pattern matching')
f3_cor = my_pattern_match(f3, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,f3);                              title('eeg1-f3(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,f3_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel f4 pattern matching')
f4_cor = my_pattern_match(f4, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,f4);                              title('eeg1-f4(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,f4_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel o1 pattern matching')
o1_cor = my_pattern_match(o1, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,o1);                              title('eeg1-o1(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,o1_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel o2 pattern matching')
o2_cor = my_pattern_match(o2, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,o2);                              title('eeg1-o2(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,o2_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel p3 pattern matching')
p3_cor = my_pattern_match(p3, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,p3);                              title('eeg1-p3(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,p3_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel p4 pattern matching')
p4_cor = my_pattern_match(p4, my_alpha);
subplot(311);       plot(t,scaled_alpha);    title('scaled Alpha wave');    xlim([0 7.5]);   xticks(0:0.5:7.5);    
subplot(312);       plot(t,p4);                              title('eeg1-p4(t)');       xlim([0 7.5]);   xticks(0:0.5:7.5);
subplot(313);       plot(t,p4_cor); title('Correlation coeff array with a 0.8 threshold');        xlabel('time(sec)');
hold on;     plot(t, 0.8*ones(1,length(t)));  xlim([0 7.5]);   xticks(0:0.5:7.5);

figure(Name='Channel f4 Power spectrum')
psd(h,f4, 'fs', Fs)
