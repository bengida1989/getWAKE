function [f] = bilinear_interp(f11, f12, f21, f22, x1, x2, y1, y2, x, y)

%% BILINEAR INTERPOLLATION ALGORTIHM  version 1.0
% Last update in: 18/10/2015
% by: Hadar Ben-Gida


%% INPUTS:
% f11 - Function value at (x1,y1)
% f12 - Function value at (x1,y2)
% f21 - Function value at (x2,y1)
% f22 - Function value at (x2,y2)
% x1 - x1 value
% x2 - x2 value
% y1 - y1 value
% y2 - y2 value
% x - The requested x value where f needs to be interpollated
% y - The requested y value where f needs to be interpollated

%% OUTPUT:
% f - Interpollated function at (x,y)
%% 


%% CALCULATING THE bij COEFFICIENTS
% b = ((A^-1)^T)*C
A = [1 x1 y1 x1*y1; 1 x1 y2 x1*y2; 1 x2 y1 x2*y1; 1 x2 y2 x2*y2];
A = transpose(inv(A));

C = [1 x y x*y]';

b = A*C;

b11 = b(1);
b12 = b(2);
b21 = b(3);
b22 = b(4);

%% THE INTERPOLLATION
f = b11*f11 + b12*f12 + b21*f21 + b22*f22;


