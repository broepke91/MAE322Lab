function [a] = myLinReg(x,y)
%MYLINREG Calculates the least squares regression to find a linear 'best
%fit' line for a given set of data points x and y.
%   Input x and y, as vectors, and the function will do the rest. Returns a
%   vector a with the
%   values of a0, a1, and E, respectively. This resembles a function of the
%   form f(x) =  a0 + a1*x.
format long; format compact;
% Calculate n
n = length(x);
% error message if the values for x and y have different lengths
if length(x) ~= length(y)
    error('x and y vectors must be of the same length');
end
% Calculate various sums for the calculations
sx = sum(x);
sy = sum(y);
sxx = sum(x.^2);
sxy = sum(x.*y);

% Define a0 and a1 per the governing equations
a0 = ((sxx*sy) - (sxy*sx)) ./ ((n*sxx) - (sx^2));
a1 = (n*sxy - sx*sy) / (n*sxx - sx^2);

% Define f as a function handle for inputting values in the loop.
f = @(x) a0 + a1*x;
% Preallocate for speed
Es = zeros(1,n);

% calculate the values for the error
for ii = 1:n
    Es(ii) = (y(ii) - f(x(ii)))^2;
end
% sum the total error
E = sum(Es);

% Define output vector
a = [a0, a1, E];
end

