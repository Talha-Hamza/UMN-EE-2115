clc;
clear;

syms s t

% Define the Laplace-transformed function F(s)
F_s = (250 * (s+7) *(s+14)) / (s*(s^2 + 14*s + 50));

% Compute the inverse Laplace transform to find f(t)
f_t = ilaplace(F_s, s, t);

% Display the result
disp('The inverse Laplace transform f(t) is:');
pretty(f_t);
