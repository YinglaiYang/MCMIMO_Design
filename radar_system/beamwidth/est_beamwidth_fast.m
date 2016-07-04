function [ bw_m2m ] = est_beamwidth_fast( px, f )
%EST_BEAMWIDTH_FAST Summary of this function goes here
%   Detailed explanation goes here
%
%   This function performs a local optimization to estimate the min2min
%   beamwidth. Note that this is not the 3dB beamwidth.
%
%   It is assumed that the range is estimated perfectly, because the array 
%   pattern with this condition has the largest beamwidth.
%
%   This function uses an array pattern, where the reference angle is -1.0.

%% 1. Parameters
c = physconst('Lightspeed');

% Physical aperture
Z_ph = max(px) - min(px);

% Virtual apertures
Z_vt_min = Z_ph * min(f) / c;
Z_vt_max = Z_ph * max(f) / c;

% Limits of beamwidth
bw_min = 1 / (2*Z_vt_max); % 2 antenna, full grating lobe model with smallest virtual aperture
bw_max = 2 / (2*Z_vt_min + 1); % fully equipped ULA model with largest virtual aperture

bw0 = (bw_min + bw_max) / 2;

% Arbitrary range value
r = 10;

u_ref = -1.0;

% theta reference
thetax_ref = [u_ref; r];

% Starting point
ux0 = u_ref + bw0; % starting point when going the distance bw0 from reference peak at -1.0 
% Maybe add a calculation to see where the starting point should lie, in
% dependance of the variance?


%% 2. The function to optimize
ap = @(ux) array_pattern_1D(f, px, [ux; r*ones(size(ux))], thetax_ref);

%% 3. Local optimization to get the m2m beamwidth
ux_lb = u_ref;
ux_ub = u_ref + bw_max;

options = optimoptions('fmincon','Display','off');

ux_min = fmincon(ap, ux0, [], [], [], [], ux_lb, ux_ub, [], options);

%% 4. Calculate the beamwidth from the location of the first minimum
bw_half = 1 + ux_min; % Distance from -1.0 to the location of min.

bw_m2m = 2 * bw_half;
end

