function [ sll, theta_SLL ] = getSLL( px, fc, maxSLL )
%GETSLL Summary of this function goes here
%   Detailed explanation goes here
c=physconst('lightspeed');

N_u=numel(px)*numel(fc)*10;
N_r=numel(fc)*10;
r_max = 0.5*c / abs(fc(2)-fc(1));
ranges = 0 + linspace(0,r_max, N_r);

% Only use a reference angle at ux=-1
ux_min = -1.0;

% End value
ux_max = 1.0;

% Eligible angle values for sidelobes
ux_sides = linspace(ux_min,ux_max,N_u).';

%% 2. Calculate grid values (do it for all ranges)
N_ux = length(ux_sides);


arraypattern=zeros(length(ranges),length(ux_sides));
if N_ux > 0
    
    c = physconst('Lightspeed');

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
        thetax = [ux_sides.'; r*ones(1, N_ux)];
        
        arraypattern(rInd,:) = P_ML_fun(thetax);
    end
    arraypattern=arraypattern/(arraypattern(1,1));
    
    %% exclude the mainlobe
    lobes=arraypattern<.5*maxSLL;
    [~,mainLobeInd]=max(lobes,[],2);
    
    for rInd=1:N_r
        arraypattern(rInd,1:mainLobeInd(rInd))=0;
    end
    
    [~,maxInd]=max(real(arraypattern(:)));
    [r_ind,u_ind] = ind2sub(size(arraypattern),maxInd);
    
    % local optimization for refinement
    [theta_SLL,sll_minus] = fminsearch(P_ML_fun,[ux_sides(u_ind);ranges(r_ind)],optimset('TolX',1e-8,'Display','none'));
    
    sll=-sll_minus/(numel(px)*numel(fc))^2;
else
    sll = NaN;
end

end

