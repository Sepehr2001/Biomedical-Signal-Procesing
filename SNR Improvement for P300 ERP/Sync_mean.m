function [time, out] = Sync_mean(EEG, Time_Constants, Sweeps_Interval, Sampling_Frequency, ref)
     Sweeps_Interval = round(Sweeps_Interval*Sampling_Frequency/1000);
     b = zeros(1,Sweeps_Interval(2)-Sweeps_Interval(1)+1);
     if ~exist('ref','var')
        ref = 0;
    end
    
    if ref == 0
        for i = 1:length(Time_Constants)
        a = EEG(Time_Constants(i) + Sweeps_Interval(1) : Time_Constants(i) + Sweeps_Interval(2));
        a = a - mean(a);
        b = b + a;
        end
        b = b/length(Time_Constants);
    end

    if ref == 1
        for i = 1:2:length(Time_Constants)
        a = EEG(Time_Constants(i) + Sweeps_Interval(1) : Time_Constants(i) + Sweeps_Interval(2));
        a = a - mean(a);
        b = b + a;
        end
        b = 2*b/length(Time_Constants);
    end
    if ref == 2
        for i = 2:2:length(Time_Constants)
            a = EEG(Time_Constants(i) + Sweeps_Interval(1) : Time_Constants(i) + Sweeps_Interval(2));
            a = a - mean(a);
            b = b + a;
        end
        b = 2*b/length(Time_Constants);
    end

    time = linspace(0, length(b)/Sampling_Frequency, length(b)) * 1000; % Signal Time in milli seconds  
    out = b;        %b is Averaged response
end