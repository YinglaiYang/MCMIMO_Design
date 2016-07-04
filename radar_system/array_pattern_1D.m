function [ ap ] = array_pattern_1D( fc, px, thetax, thetax_ref )
%ARRAY_PATTERN Summary of this function goes here
%   Detailed explanation goes here

c = physconst('Lightspeed');

% columnize
px = px(:);
fc = fc(:);

% B matrix
Bx = 2*pi/c * [kron(fc, px), -2*kron(fc, ones(size(px)))];

% Calculate the beam vectors
a = exp(1j*Bx*thetax);
a_ref = exp(1j*Bx*thetax_ref);

% Calculate the resulting value of the array pattern at the given point
ap = abs(a'*a_ref).^2;

end

