clc, clear, close all;
addpath(genpath('../radar_system'));
addpath(genpath('../radar_system/beamwidth'));

% This script optimizes a 4x4 MIMO radar with 2 carrier frequencies. The
% lower frequency is optimized, while the higher carrier frequency is
% fixed.

%% 1. All parameters
c = physconst('Lightspeed');

SLLmax = 0.2;

N_ant_tx = 4; M = N_ant_tx;
N_ant_rx = 4; N = N_ant_rx;

N_ant = N_ant_tx + N_ant_rx;
nvars = N_ant-2+0; %N_ant - 2 positional variables + 1 freq (Both tx and rx arrays have one fixed antenna)

f0 = 100e9; %[Hz] fixed frequency

% Define a minimum distance for the antennas in the array.
f_ref = 100e9;
lambda_ref = c/f_ref;

%% Create struct
env.N_ant_tx = N_ant_tx;
env.N_ant_rx = N_ant_rx;
env.N_freq = 1;

env.p0_tx = 0;
env.p0_rx = 0;
env.f0 = f0;


% Development information
% -----------------------
% Vector for cost function:
% [ptx1, .., ptxM, prx1, .., prxN, f1]
%
% NOTE: Both tx and rx arrays have one fixed antenna each. That means that
% only N_ant_TX - 1 and N_ant_RX - 1 or N_ant - 2 antenna positions have to be
% optimized.


tic
% Design limits
% -------------
% 1. Sensor size limits max aperture
Z_max = 30e-2; %[m]
% 2. Minimum distance between antennas
d_min = lambda_ref/2; %[m] CURRENTLY ARBITRARY

%% 2. Setup the parameter space for antenna positions
p0_tx = 0; % First antenna is fixed!
p0_rx = 0;




%% 3. The functions that are used
sigma = 1; %arbitrary value
rho = N_ant;

% Cost function (CRB of system)
% Assumptions:
% - power identical for all frequencies
% - power identical for all antenna positions
% - p_x is centered to 0 by this function
% cfun = @(x) ...
%             1/(f(x)' * f(x)) / var(p(x),1);
cfun = @(x) cfun_template(x,env);

% SLL function        
N_r = 20;

% est_sll_fun = @(x, bw) getSLL_universal(p(x), f(x), bw, N_r);
% 
% %--------
% vt_gcd_fun = @(x) d_min * mgcd(f(x));
% est_bw_fun = @(x) est_beamwidth_fast(p(x), f(x));

nl_confun = @(x) nl_constraints3(x, SLLmax, env);


%% 4. Constraints
A=[];
b=[];

% Other constraints
Aeq = [];
beq = [];

% Bounds
lb_px = zeros(1,N_ant-2);
ub_px = Z_max * ones(1,N_ant-2);

lb_f = [80e9];
ub_f = [95e9];

lb = lb_px;%[lb_px, lb_f];
ub = ub_px;%[ub_px, ub_f];

assert(isequal(size(lb), size(ub))); 
assert(isequal(size(lb), [1,nvars])); %make sure that each variable has its own bounds


%% 5. Parameters for GA

%% 6. Optimize:
options = gaoptimset('PopulationSize',20000, ... 
                     'NonlinConAlgorithm','auglag', ...
                     'CreationFcn',@gacreationlinearfeasible, ...
                     'TolFun',1e-6, ...
                     'Display','iter', ...
                     'PlotFcn',@gaplotbestf, ...
                     'UseParallel',true);
                 
% Using the 'penalty' algorithm for nonlinear constraints would require the CreationFcn: @gacreationnonlinearfeasible  

[p_opt, crb_opt, exitflag, output, final_population, final_scores] = ga(cfun, nvars, A, b, Aeq, beq, lb, ub, nl_confun, options);

save('workspace_reducedUniversalGA_SC.mat')

toc

exit
