function [f,out] = my_fft(fun, sampling_freq)
    y = fft(fun);
    y = abs(y/length(fun));
    y = y(1:(end/2) +1);
    y(2:end-1) = 2*y(2:end-1);
    f = sampling_freq/length(fun) * (0:(length(fun)/2));
    out=y;
end