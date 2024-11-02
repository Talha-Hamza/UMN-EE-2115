%% Series RLC Transient Circuit Analysis with Voltage Transfer across Resistor and Frequency Response

% Clear workspace and command window
clear;
clc;

% Define symbolic variables
syms iL(t) vC(t)

% Circuit parameters
R = 25;          % Resistance in ohms
L = 50.3e-3;     % Inductance in henrys
C = 31e-6;       % Capacitance in farads

% Initial conditions
i0 = 0;          % Initial inductor current
v0 = 5000;       % Initial capacitor voltage

% Define differential equations
DiL = diff(iL, t);
D2iL = diff(iL, t, 2);

% Coefficient of 1st order derivative defines the degree of damping
dFac = R/L;

% Natural resonance frequency
wo2 = 1/(L*C);

% Initial value of the first derivative of inductor current
Di0 = (-R*i0 - v0)/L;

% Solve the differential equation for iL
iL = dsolve(D2iL == -dFac*DiL - wo2*iL, iL(0) == i0, DiL(0) == Di0);

% Evaluate inductor current as function of time (symbolic integration)
vC = (1/C)*int(iL, t, 0, t) + v0;

% Convert symbolic expressions to MATLAB functions for plotting
iL_func = matlabFunction(iL);
vC_func = matlabFunction(vC);

% Time vector for plotting
t = linspace(0, 0.05, 1000);
A = subs(vpa(iL_func,4),t);

% Calculate resistor voltage
V_R = R * iL_func(t);

% Plot results
figure(1);

% Plot inductor current
subplot(3,1,1);
plot(t, iL_func(t), 'LineWidth', 1.5);
title('Inductor Current i_L(t)');
xlabel('Time (s)');
ylabel('Current (A)');
grid on;

% Plot capacitor voltage
subplot(3,1,2);
plot(t, vC_func(t), 'LineWidth', 1.5);
title('Capacitor Voltage v_C(t)');
xlabel('Time (s)');
ylabel('Voltage (V)');
grid on;

% Plot resistor voltage
subplot(3,1,3);
plot(t, V_R, 'LineWidth', 1.5);
title('Resistor Voltage V_R(t)');
xlabel('Time (s)');
ylabel('Voltage (V)');
grid on;
%%
% 
% Settling time evaluation
%
figure(2)

maxA= max(abs(A));
AA= abs(A)/max(abs(A));

semilogy(t,[AA' 0.01*ones(size(AA(:)))],'LineWidth',1.5); grid on
title(['Normalized |\it {i}_{L}|'])
xlabel('Time, s')
ylabel('Normalized Value')