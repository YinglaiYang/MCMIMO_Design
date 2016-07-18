function [ ap ] = arrayPattern( px, fc, N_ux, N_r )
%ARRAYPATTERN The array pattern of a linear array
%   Detailed explanation goes here

c=physconst('lightspeed');

if numel(fc) == 1
    r_max = 0;
    ranges = 0;
else
    r_max = 0.5*c / abs(fc(2)-fc(1));
    ranges = 0 + linspace(0,r_max, N_r);
end


% Only use a reference angle at ux=-1
ux_min = -1.0;

% End value
ux_max = 1.0;

% Eligible angle values for sidelobes
ux = linspace(ux_min,ux_max,N_ux).';

%% 2. Calculate grid values (do it for all ranges)
ap=zeros(length(ranges),length(ux));

% columnize
px = px(:);
fc = fc(:);

% B matrix
Bx = 2*pi/c * [kron(fc, px), -2*kron(fc, ones(size(px)))];

% Calculate the beam vectors
thetax_ref = [-1; 0];

a_ref = exp(1j*Bx*thetax_ref);

% Calculate the resulting value of the array pattern at the given point
a=@(theta)(exp(1j*Bx*theta));
P_ML_fun=@(theta)(-(abs(a(theta)'*a_ref)).^2);
for rInd=1:length(ranges)
    r=ranges(rInd);
    thetax = [ux.'; r*ones(1, N_ux)];

    ap(rInd,:) = P_ML_fun(thetax);
end
ap=ap/(ap(1,1));


end

