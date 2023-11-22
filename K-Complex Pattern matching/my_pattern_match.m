function c_corr_matrix = my_pattern_match(fun, pattern)
    a = zeros(1,length(fun));
    for i = 1:length(fun)-length(pattern)
        a(i) = corr(pattern', fun(i:i+length(pattern)-1)');
    end
    c_corr_matrix = a;
  %  t = linspace(0, length(a)/sampling_freq, length(a));
end
