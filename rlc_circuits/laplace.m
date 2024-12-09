clc;
clear;

syms t s

% Define unit step functions
u2 = heaviside(t - 2);
u4 = heaviside(t - 4);
u8 = heaviside(t - 8);
u10 = heaviside(t - 10);

% Define f(t) as given in the problem
f_t = (5*t - 10) * (u2 - u4) + (30 - 5*t) * (u4 - u8) + (5*t - 50) * (u8 - u10);
% f_t = (30 - 5*t) * (u4 - u8);
% Compute the Laplace transform of f(t)
F_s = laplace(f_t, t, s);

% Display the result
disp('The Laplace transform of f(t) is:');
pretty(F_s);
