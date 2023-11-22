function out = SNR_estimate(EEG, Time_Constants, Sweeps_Interval, Sampling_Frequency ,number_of_sweeps)
    Sweeps_Interval = round(Sweeps_Interval*Sampling_Frequency/1000);
  
    b = zeros(1,Sweeps_Interval(2) - Sweeps_Interval(1) +1);
    b1 = zeros(1,Sweeps_Interval(2) - Sweeps_Interval(1) +1);
    b2 = zeros(1,Sweeps_Interval(2) - Sweeps_Interval(1) +1);

    c = zeros(1,length(number_of_sweeps));
    for k = 1:length(number_of_sweeps)

        for i = 1:number_of_sweeps(k)
            a = EEG(Time_Constants(i) + Sweeps_Interval(1) : Time_Constants(i) + Sweeps_Interval(2));
            a = a - mean(a);
            b = b + a;
        end
        b = b/number_of_sweeps(k);

        for i = 1:2:number_of_sweeps(k)
            a = EEG(Time_Constants(i) + Sweeps_Interval(1) : Time_Constants(i) + Sweeps_Interval(2));
            a = a - mean(a);
            b1 = b1 + a;
        end
        b1 = 2*b1/number_of_sweeps(k);

        for i = 2:2:number_of_sweeps(k)
            a = EEG(Time_Constants(i) + Sweeps_Interval(1) : Time_Constants(i) + Sweeps_Interval(2));
            a = a - mean(a);
            b2 = b2 + a;
        end
        b2 = 2*b2/number_of_sweeps(k);

        c(k) = var(b)/var(b2-b1);
    end
   
    out = c;       
end