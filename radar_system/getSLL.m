function [ sll, theta_SLL ] = getSLL( px, ranges, r_ref, fc, bw )
%GETSLL Summary of this function goes here
%   Detailed explanation goes here

% Resulting spacing of grid to calculate sll
d_ux = bw/10;

% Only use a reference angle at ux=-1
ux_ref = -1.0;

% Starting value of ux (first value outside of main lobe)
ux_min = ux_ref + bw/2;

% End value
ux_max = 1.0;

% Eligible angle values for sidelobes
ux_sides = (ux_min:d_ux:ux_max).';

%% 2. Calculate grid values (do it for all ranges)
N_ux = length(ux_sides);
N_r  = length(ranges);

if N_ux > 0
    max_ap_val = NaN(N_r, 1);
    max_ap_uInd = NaN(N_r, 1);

    thetax_ref = [ux_ref; r_ref];

    for rInd = 1:length(ranges)
        r = ranges(rInd);

        thetax = [ux_sides.'; r*ones(1, N_ux)];

        ap = array_pattern_1D(fc, px, thetax, thetax_ref);

        [max_ap_val(rInd), max_ap_uInd(rInd)] = max(ap);
    end

    [max_ap_overall, max_ap_rInd] = max(max_ap_val);

    %% 3. Local optimization to get an exact value
    apfun = @(theta) -array_pattern_1D(fc, px, theta, thetax_ref);

    [theta_SLL, sll_neg] = fminsearch(apfun, [ux_sides(max_ap_uInd(max_ap_rInd)); ranges(max_ap_rInd)], optimset('TolX',1e-8, 'Display','off'));

    % Make it positive again and normalize the result
    sll = -sll_neg / array_pattern_1D(fc, px, thetax_ref, thetax_ref);
else
    sll = NaN;
end

end

