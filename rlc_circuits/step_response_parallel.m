% Step Response of Parallel RLC Circuit
clear; clc;

R = 40;       % value in Ohms
L = 250e-3;      % value in Henrys
C = 25e-6;    % value in Farads
V0 = 75;        % value in Volts
I0 = 0.1;         % value in Amps
IF = 0.1;         % value in Amps
t_end = 0;      % Graphing time range. IF this is set 0, code will dynamically adjust the best range

% Step 2: Calculate alpha, omega_0, and omega_d
alpha = 1 / (2 * R * C);             % Neper frequency (damping factor)
omega_0 = 1 / sqrt(L * C);           % Resonant frequency
omega_d = sqrt(omega_0^2 - alpha^2); % Damped frequency (if underdamped)

% Determine the type of damping
if alpha > omega_0
    disp('The response is overdamped.');
    % Step 3: Overdamped roots
    s1 = -alpha + sqrt(alpha^2 - omega_0^2);
    s2 = -alpha - sqrt(alpha^2 - omega_0^2);
    
    syms A1 A2
    % Define the equations
    eq1 = IF + A1 + A2 == I0;
    eq2 = s1 * A1 + s2 * A2 == V0/L;
    
    % Solve the system of equations
    solution = solve([eq1, eq2], [A1, A2]);
    
    % Display the results
    A1_value = double(solution.A1);
    A2_value = double(solution.A2);
    
    % Step 5: Construct v(t) for overdamped response
    syms t;
    i_t = (A1_value * exp(s1 * t) + A2_value * exp(s2 * t)) + IF;
    
elseif alpha < omega_0
    disp('The response is underdamped.');  
    % Step 4: Solve for constants B1 and B2 using initial conditions
    B1 = I0 - IF;
    B2 = ((V0/L) + (alpha * B1)) / omega_d;
    
    % Step 5: Construct v(t) for underdamped response
    syms t;
    i_t = exp(-alpha * t) * (B1 * cos(omega_d * t) + B2 * sin(omega_d * t)) + IF;
    
else
    disp('The response is critically damped.');  
    % Step 4: Solve for constants D1 and D2 using initial conditions
    D2 = I0 - IF;
    D1 = (V0/L) + (alpha * D2);
    
    % Step 5: Construct v(t) for critically damped response
    syms t;
    i_t = ((D1* t + D2) * exp(-alpha * t)) + IF;
end
% Display the inductor current response i(t)
disp('The inductor current response i(t) is:');
i_t_numeric = vpa(i_t, 4); % display symbolic expression accurate up to 4 significant numbers
disp(i_t_numeric);

% Step 6: Calculate the inductor voltage v_L = L * di/dt
v_L = L * diff(i_t, t);

% Display the inductor voltage response v_L(t)
disp('The inductor voltage response v_L(t) is:');
v_L_numeric = vpa(v_L, 4); % display symbolic expression accurate up to 4 significant numbers
disp(v_L_numeric);

if t_end == 0
    % Step 6: Dynamically adjust plot range if no time range is given
    t_end = 5 / alpha;  % Set x-axis range based on alpha (for better time scale)
end
% Evaluate the functions over the desired time range
time_vals = linspace(0, t_end, 200); % Generate points between 0 and t_end
i_vals = double(subs(i_t, t, time_vals)); % Evaluate i(t) at these points
vL_vals = double(subs(v_L, t, time_vals)); % Evaluate v_L(t) at these points

% Plot the responses i(t) and v_L(t)
figure;
subplot(2, 1, 1);
plot(time_vals, i_vals, 'b', 'LineWidth', 1.5);
title('Inductor Current i(t)');
xlabel('Time (s)');
ylabel('Current (A)');
grid on;

subplot(2, 1, 2);
plot(time_vals, vL_vals, 'r', 'LineWidth', 1.5);
title('Inductor Voltage v_L(t)');
xlabel('Time (s)');
ylabel('Voltage (V)');
grid on;