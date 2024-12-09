syms s t RL Rs C L Vcc;
%Use the B/A and find the ILT for a step function
RL = 4;
Rs = 1;
C = 1e-6;
L = 22e-6;
Vcc = 10;
B = Vcc*[0, 0*RL*C, RL];%*(1-exp(-1*1e-4*s));
A = [RL*L*C, Rs*RL*C+L, RL+Rs];
% Create transfer functions
%numerator = B(1)*s^2 + B(2)*s + B(3);
%denominator = A(1)*s^3 + A(2)*s^2 + A(3)*s;
%H = tf(numerator, denominator);
% Use ilaplace to find the inverse Laplace transform
%iL = ilaplace(H);
VC = (B(1)*s^2 + B(2)*s + B(3)) / (A(1)*s^3 + A(2)*s^2 + A(3)*s);
% Use ilaplace to find the inverse Laplace transform
VC = ilaplace(VC);
% Display the symbolic expression with 4 decimal places
disp(vpa(VC, 4));
% Plot the time response
figure(3);
tEnd = 200e-6;
fplot(VC, [0 tEnd], 'LineWidth', 1.5);
grid on;
axis([0 200e-6 0 2.5])
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Voltage Response');
