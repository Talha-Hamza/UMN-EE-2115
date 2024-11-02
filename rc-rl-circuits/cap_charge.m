% Time Vector (ps) with higher resolution
t = linspace(-25, 800, 2000);  % Start time from -100 to 600 ps

% Constants for Capacitor Response
tau1 = 100;  % Time constant for discharge (ps)
tau2 = 100; % Time constant for recovery (ps)
V_initial = 0;  % Initial voltage (near 5V)
V_min = 5;  % Minimum voltage dip after pulse
signal_time = 600;  % End of TTL pulse
% TTL Input Pulse (5V for 100 ps)
TTL_pulse = 5 * (t >= 0 & t <= signal_time);  % Pulse high from 0 to 100 ps

% Pre-allocate capacitor voltage array
V_capacitor = zeros(size(t));
V_capacitor(1) = V_initial;  % Set initial voltage to 5V

% Simulate the capacitor response: voltage dip + slow rise
final_iteration = V_initial;  % Initialize final value to 5V
for i = 1:length(t)
    if t(i) <= signal_time
        % Discharge phase (during the pulse duration)
        V_capacitor(i) = V_min + (V_initial - V_min) * exp(-t(i) / tau1);
        final_iteration = V_capacitor(i);  % Save final value before recovery
    else
        % Recovery phase (after the pulse ends)
        V_capacitor(i) = V_initial + (final_iteration - V_initial) * exp(-(t(i) - signal_time) / tau2);
    end
end

% Plotting the TTL pulse and capacitor response
figure;
hold on;

% Plot the TTL Pulse (Blue Line)
plot(t, TTL_pulse, 'b--', 'LineWidth', 2);

% Plot the Capacitor Response (Red Line)
plot(t, V_capacitor, 'r', 'LineWidth', 2);

% Add labels, title, and legend
xlabel('Time (ps)');
ylabel('Voltage (V)');
title('Response of Inverter to 5V Pulse');
legend('Input Voltage (V_{in})', 'Output Voltage (V_{out})', 'Location', 'best');

% Customize grid and axes limits
grid on;
axis([-100 800 0 5.5]);  % Set axis limits

% Set y-axis ticks from 0 to 5 with 0.5 intervals
yticks(0:0.5:5.5);

% Display the plot
hold off;

% Increase the number of decimal places for the display (optional)
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')', '%.2f'));