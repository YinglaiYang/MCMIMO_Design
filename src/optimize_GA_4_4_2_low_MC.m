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
nvars = N_ant-2+1; %N_ant - 2 positional variables + 1 freq (Both tx and rx arrays have one fixed antenna)

f0 = 100e9; %[Hz] fixed frequency

% Define a minimum distance for the antennas in the array.
f_ref = 100e9;
lambda_ref = c/f_ref;

%% Create struct
env.N_ant_tx = N_ant_tx;
env.N_ant_rx = N_ant_rx;
env.N_freq = 2;

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
%% 4.2 Maximum aperture
% Maybe this could become a linear constraint when the strict order
% constraint is enforced in the nonlinear constraint functions
% A = [-1  0   0;
%       1 -1   0];

% This linear constraint enforces the antennas to keep a minimum distance
% from each other
%
% 1. The TX antennas
antennas_tx      = -ones(1,N_ant_tx-1);
prev_antennas_tx = +ones(1,N_ant_tx-2);
A_tx = [diag(antennas_tx) + diag(prev_antennas_tx,-1)];
% 2. The RX antennas
antennas_rx      = -ones(1,N_ant_rx-1);
prev_antennas_rx = +ones(1,N_ant_rx-2);
A_rx = [diag(antennas_rx) + diag(prev_antennas_rx,-1)];

% Combine into one matrix
A_comb = zeros(M+N-2, M+N-2);
A_comb(1:M-1,1:M-1) = A_tx;
A_comb(M:end,M:end) = A_rx;

A = [A_comb, zeros(M+N-2,1)];


b = -d_min * ones(N_ant-2,1);

A=[];
b=[];


assert(isequal(size(A), [N_ant-2,nvars])); %make sure that we have one min. spacing constraint for each free antenna
assert(isequal(size(b), [N_ant-2,1]));
 
% Other constraints
Aeq = [];
beq = [];

% Bounds
lb_px = zeros(1,N_ant-2);
ub_px = Z_max * ones(1,N_ant-2);

lb_f = [80e9];
ub_f = [95e9];

lb = [lb_px, lb_f];
ub = [ub_px, ub_f];

assert(isequal(size(lb), size(ub))); 
assert(isequal(size(lb), [1,nvars])); %make sure that each variable has its own bounds


%% 5. Parameters for GA

%% 6. Optimize:
options = gaoptimset('MutationFcn',@mutationadaptfeasible, ...
                     'PopulationSize',20000, ... 
                     'NonlinConAlgorithm','auglag', ...
                     'CreationFcn',@gacreationlinearfeasible, ...
                     'TolFun',1e-6, ...
                     'Display','iter', ...
                     'PlotFcn',@gaplotbestf, ...
                     'UseParallel',true);
                 
% Using the 'penalty' algorithm for nonlinear constraints would require the CreationFcn: @gacreationnonlinearfeasible  

[p_opt, crb_opt, exitflag, output, final_population, final_scores] = ga(cfun, nvars, A, b, Aeq, beq, lb, ub, nl_confun, options);

save('workspace_reducedUniversalGA_MC.mat')

toc

exit
