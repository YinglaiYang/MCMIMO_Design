function [ bw_m2m ] = est_beamwidth_m2m( px, f, N_points )
%EST_BEAMWIDTH_M2M Estimates the min2min beamwidth.
%   This function performs a local optimization to estimate the min2min
%   beamwidth. Note that this is not the 3dB beamwidth.
%
%   It is assumed that the range is estimated perfectly, because the array 
%   pattern with this condition has the largest beamwidth.
%
%   This function uses an array pattern, where the reference angle is -1.0.

%% 1. Parameters
% Arbitrary range value
r = 10;

% Starting point
ux0 = linspace(-1.0, 1.0, N_points);

% theta reference
thetax_ref = [-1.0; r];

%% 2. The function to optimize
ap = @(ux) array_pattern_1D(f, px, [ux; r*ones(size(ux))], thetax_ref);

%% 3. Local optimization to get the m2m beamwidth
ux_lb = -1.0;
ux_ub =  1.0;

options = optimoptions('fmincon','Display','off');

ux_min = NaN(1,N_points);

for n=1:N_points
    ux_min(n) = fmincon(ap, ux0(n), [], [], [], [], ux_lb, ux_ub, [], options);
end

ux_firstMin = min(ux_min);

%% 4. Calculate the beamwidth from the location of the first minimum
bw_half = 1 + ux_firstMin; % Distance from -1.0 to the location of min.

bw_m2m = 2 * bw_half;
end

