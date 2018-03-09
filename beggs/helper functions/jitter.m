function jittered_times = jitter(spike_times)
%jitter(spike_times, jitter_size) jitters spike times randomly forward and
%back by jitter_size
jitter_size = 19;
jittered_times = spike_times + jitter_size * ...
    (ones(size(spike_times)) - 2*(rand(size(spike_times)) < 0.5));
end

