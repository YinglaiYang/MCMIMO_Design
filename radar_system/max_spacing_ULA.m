function [ d_max, lambda_gcd ] = max_spacing_ULA( fc )
%MAX_SPACING_ULA Maximal antenna spacing for multicarrier ULA without
%grating lobes.
%   Detailed explanation goes here

%% New algorithm based on GCD
c=physconst('Lightspeed');

% gcd can't be used with an array as input, so we need to use this trick to
% get the array elements as individual function parameters:
fc_cell = num2cell(fc); 
fc_gcd = gcd(fc_cell{:});

% The results:
lambda_gcd = c / fc_gcd;

d_max = 0.5 * lambda_gcd;
end

