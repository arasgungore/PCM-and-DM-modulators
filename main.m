%% Task 1: Pulse Code Modulation

% Clear the workspace and figures

clear, close all



% Define message signal


% message signal properties

message_frequency_cosine = 100;     % in Hertz (Hz)
message_frequency_sine = 25;        % in Hertz (Hz)
message_amplitude_cosine = -1;      % (usually) in Volts (V)
message_amplitude_sine = 1;         % (usually) in Volts (V)


% the component with the highest frequency carries the bandwidth

bandwidth = max([message_frequency_cosine, message_frequency_sine]);	% in Hertz (Hz)
sampling_frequency = 2 * bandwidth;         % Nyquist sampling frequency in Hertz (Hz)


% initialize the time vector

signal_duration = 2;                % in seconds (s)

% sampling starts from t_0 = Ts
time = (1:(signal_duration * sampling_frequency - 1)) ./ sampling_frequency;


% calculate the message signal

message_cosine = message_amplitude_cosine .* cos(2 * pi * message_frequency_cosine * time);
message_sine = message_amplitude_sine .* sin(2 * pi * message_frequency_sine * time);
message = message_cosine + message_sine;


% calculate the new message signal with higher time sensitivity

new_frequency = 1e6;
new_time = (1:(signal_duration * new_frequency - 1)) ./ new_frequency;
new_message_cosine = message_amplitude_cosine .* cos(2 * pi * message_frequency_cosine * new_time);
new_message_sine = message_amplitude_sine .* sin(2 * pi * message_frequency_sine * new_time);
new_message = new_message_cosine + new_message_sine;


% calculate the negative and positive peak values using new message signal for more accuracy

amplitude_pmax = max(new_message);	% find the positive peak amplitude
amplitude_nmax = min(new_message);	% find the negative peak amplitude




% Define Pulse Code Modulation (PCM) properties


L = 128;                            % number of quantization levels
no_of_bits = int32(log2(L));        % number of bits (2^n = L)
level_limits = linspace(amplitude_pmax, amplitude_nmax, L + 1);     % L + 1 level limits


% take averages of the successive level limits to obtain quantization levels

quantization_levels = (level_limits(1:L) + level_limits(2:end)) / 2;




% Define the actual modulator


% define the quantized message signal

quantized_message = zeros('like', message);


% go through the modulation loop

for i = 1:length(message)
    amplitude_diffs = abs(message(i) - quantization_levels);
    
    % find the first index where the amplitude difference is greater than or equal to the one before it
    % if such index doesn't exist then set the quantized level as L - 1,
    % otherwise set the quantized level as the index before the one we have just found
    quantized_level = find(amplitude_diffs(2:end) >= amplitude_diffs(1:(L - 1)), 1);
    if isempty(quantized_level)
        quantized_message(i) = L - 1;
    elseif quantized_level > 1
        quantized_message(i) = quantized_level - 1;
    end
end




% Display the binary representation of the first 10 samples on the screen

output = arrayfun(@(x) dec2bin(x, no_of_bits), quantized_message(1:10), 'UniformOutput', false);
fprintf('%s', output{1})
fprintf('-%s', output{2:end})
fprintf('\n')

%% Task 2: Delta Modulation

% Clear the workspace and figures

clear, close all



% Define message signal


% initialize the time vector

sampling_frequency = 1e6;           % in Hertz (Hz)
signal_duration = 2;                % in seconds (s)
time = (0:(signal_duration * sampling_frequency - 1)) ./ sampling_frequency;


% message signal properties

message_frequency_cosine = 100;     % in Hertz (Hz)
message_frequency_sine = 25;        % in Hertz (Hz)
message_amplitude_cosine = -1;      % (usually) in Volts (V)
message_amplitude_sine = 1;         % (usually) in Volts (V)


% calculate the message signal

message_cosine = message_amplitude_cosine .* cos(2 * pi * message_frequency_cosine * time);
message_sine = message_amplitude_sine .* sin(2 * pi * message_frequency_sine * time);
message = message_cosine + message_sine;




% Define Delta Modulation (DM) properties


% the component with the highest frequency carries the bandwidth

bandwidth = max([message_frequency_cosine, message_frequency_sine]);	% in Hertz (Hz)


% define delta sampling frequency as 4 times the Nyquist rate

nyquist_rate_factor = 4;
delta_sampling_frequency = nyquist_rate_factor * 2 * bandwidth;         % in Hertz (Hz)


delta_epsilon = 0.2;        % define step size in seconds (s)




% Define the actual modulator


% define sample time array

delta_time = (0:(signal_duration * delta_sampling_frequency - 1)) ./ delta_sampling_frequency;


% calculate the sampled message signal

sampled_message_cosine = message_amplitude_cosine * cos(2 * pi * message_frequency_cosine * delta_time);
sampled_message_sine = message_amplitude_sine * sin(2 * pi * message_frequency_sine * delta_time);
sampled_message = sampled_message_cosine + sampled_message_sine;


% allocate memory

prediction = zeros(length(sampled_message), 1);
modulated = zeros('like', prediction);


% go through the modulation loop

for i = 2:length(sampled_message)
    amplitude_diff = sampled_message(i) - prediction(i - 1);
    modulated(i) = (2 * double(amplitude_diff > 0) - 1) * delta_epsilon;
    prediction(i) = prediction(i - 1) + modulated(i);
end




% Print the first 20 samples on the screen

output = int32(modulated(2:21) > 0);
fprintf('%d', output(1))
fprintf('-%d', output(2:end))
fprintf('\n')




% Plot obtained signals (optional)


% define plot parameters

plot_time = 0.1;


% plot the message and predicted signals

subplot(2, 1, 1)
plot(time, message, 'b')
% stairs(delta_time, sampled_message, 'c--')
hold on
stairs(delta_time, prediction, 'r')
xlabel('Time (s)')
ylabel('Amplitude')
title('Message and Predicted Signals', 'Color', 'r')
legend('Message signal', 'Predicted signal', 'Location', 'Southwest')
axis([0, plot_time, -2, 2])
grid on


% plot the transmitted DM signal

subplot(2, 1, 2)
stem(delta_time, modulated, 'b')
xlabel('Time (s)')
ylabel('Amplitude')
title('Transmitted DM Signal', 'Color', 'r')
axis([0, plot_time, -2*delta_epsilon, 2*delta_epsilon])
grid on
