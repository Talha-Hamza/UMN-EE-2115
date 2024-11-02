% Natural Response of Parallel RLC Circuit
clear; clc;

R = 200;    % value in Ohms
L = 62.5;  % value in Henrys
C = 25e-6; % value in Farads
V0 = 0;
I0 = 0; 
t_end = 7e-3;  % Graphing time range. IF this is set 0, code will dynamically adjust the best range

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
    eq1 = A1 + A2 == V0;
    eq2 = s1 * A1 + s2 * A2 == (1 / C) * (-V0 / R - I0);
    
    % Solve the system of equations
    solution = solve([eq1, eq2], [A1, A2]);
    
    % Display the results
    A1_value = double(solution.A1);
    A2_value = double(solution.A2);
    
    % Step 5: Construct v(t) for overdamped response
    syms t;
    v_t = A1_value * exp(s1 * t) + A2_value * exp(s2 * t);
    
elseif alpha < omega_0
    disp('The response is underdamped.');
    % Step 3: Underdamped roots
    s1 = -alpha + 1i * omega_d;
    s2 = -alpha - 1i * omega_d;
    
    % Step 4: Solve for constants B1 and B2 using initial conditions
    B1 = V0;
    B2 = (((1/C)*((-V0/R)-I0)) + (alpha * B1)) / omega_d;
    
    % Step 5: Construct v(t) for underdamped response
    syms t;
    v_t = exp(-alpha * t) * (B1 * cos(omega_d * t) + B2 * sin(omega_d * t));
    
else
    disp('The response is critically damped.');
    % Step 3: Critically damped roots
    s1 = -alpha;
    
    % Step 4: Solve for constants D1 and D2 using initial conditions
    D2 = V0;
    D1 = (((1/C)*((-V0/R)-I0)) + (alpha * D2));
    
    % Step 5: Construct v(t) for critically damped response
    syms t;
    v_t = (D1* t + D2) * exp(-alpha * t);
end
% Display the result with 2 decimal places
disp('The voltage response v(t) is:');
v_t_numeric = vpa(v_t, 4); % display symbolic expression accurate up to 4 significant numbers
disp(v_t_numeric);

if t_end == 0
    % Step 6: Dynamically adjust plot range if no time range is given
    t_end = 5 / alpha;  % Set x-axis range based on alpha (for better time scale)
end

% Evaluate the function over the desired time range to find max and min
time_vals = linspace(0, t_end, 200); % Generate 100 points between 0 and t_end
v_vals = double(subs(v_t, t, time_vals)); % Evaluate v(t) at these points

y_max = max(v_vals);  % Get the maximum voltage response
y_min = min(v_vals);  % Get the minimum voltage response

% Plot the response v(t)
fplot(v_t, [0, t_end], 'LineWidth', 1.5);
title('Natural Response of Parallel RLC Circuit');
xlabel('Time (s)');
ylabel('Voltage v(t) (Volts)');
ylim([y_min * 1.2, y_max * 1.2]);  % Set y-axis range with a margin
grid on;