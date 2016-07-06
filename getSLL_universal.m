function [ sll ] = getSLL_universal( px, f, bw, N_r )
%GETSLL_UNIVERSAL Summary of this function goes here
%   Detailed explanation goes here

c = physconst('Lightspeed');

% Define ranges for SLL calculation
r_ref = 10;

if length(f) > 1
    r_max = 0.5*c / abs(f(2)-f(1));

    ranges = r_ref + linspace(-r_max, 0, N_r);
else
    ranges = r_ref;
end

sll = getSLL(px, ranges, r_ref, f, bw);

end

