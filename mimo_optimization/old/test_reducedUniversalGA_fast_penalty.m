clc, clear, close all;
addpath(genpath('../../radar_system'));
addpath(genpath('../../radar_system/beamwidth'));
addpath(genpath('../../study/OPT2'));

% This script uses an genetic algorithm to find an optimum array
% configuration. It uses the same parameters and functions as the
% visualization example `simplevis.m`. It also optimizes one freuency 
% together with the antenna positions.
%
% That way it is comparable.



%% 1. All parameters
c = physconst('Lightspeed');

SLLmax = 0.2;

N_ant = 8;
nvars = N_ant; %N_ant - 1 positional variables + 1 freq

f0 = 80e9; %[Hz] fixed frequency
lambda0 = c/f0;



% Development information
% -----------------------
% Vector for cost function:
% [p1, p2, p3, p4, p5, p6, p7, f1] - Seven free antennas and two free frequencies. The first
%                                    antenna p0 is fixed at 0.
%
pos_ind = 1:nvars-1;   % [0, x(pos_ind)] -> px
freq_ind = nvars;      % [f0, x(freq_ind)] -> f





tic
% Design limits
% -------------
% 1. Sensor size limits max aperture
Z_max = 3e-2; %[m]
% 2. Minimum distance between antennas
d_min = lambda0/2; %[m] CURRENTLY ARBITRARY

%% 2. Setup the parameter space for antenna positions
p0 = 0; % First antenna is fixed!



%%
p = @(x) [p0, x(pos_ind)].';
f = @(x) [f0, x(freq_ind)].';



%% 3. The functions that are used
sigma = 1; %arbitrary value
rho = N_ant;

% Cost function (CRB of system)
% Assumptions:
% - power identical for all frequencies
% - power identical for all antenna positions
% - p_x is centered to 0 by this function
cfun = @(x) ...
            0.5 * sigma^2/rho * (lambda0/(2*pi))^2 / var(p(x),1);

% SLL function        
N_r = 20;

est_sll_fun = @(x, bw) getSLL_universal(p(x), f(x), bw, N_r);

%--------
vt_gcd_fun = @(x) d_min * mgcd(f(x));
est_bw_fun = @(x) est_beamwidth_fast(p(x), f(x));

nl_confun = @(x) nl_constraints3(x, est_bw_fun, est_sll_fun, SLLmax);


%% 4. Constraints
%% 4.2 Maximum aperture
% Maybe this could become a linear constraint when the strict order
% constraint is enforced in the nonlinear constraint functions
% A = [-1  0   0;
%       1 -1   0];

% This linear constraint enforces the antennas to keep a minimum distance
% from each other
antennas      = -ones(1,N_ant-1);
prev_antennas = +ones(1,N_ant-2);

A = [diag(antennas) + diag(prev_antennas,-1), zeros(N_ant-1,1)];


b = -d_min * ones(N_ant-1,1);


assert(isequal(size(A), [N_ant-1,nvars])); %make sure that we have one min. spacing constraint for each free antenna
assert(isequal(size(b), [N_ant-1,1]));
 
% Other constraints
Aeq = [];
beq = [];

% Bounds
lb_px = zeros(1,N_ant-1);
ub_px = Z_max * ones(1,N_ant-1);

lb_f = [80e9];
ub_f = [100e9];

lb = [lb_px, lb_f];
ub = [ub_px, ub_f];

assert(isequal(size(lb), size(ub))); 
assert(isequal(size(lb), [1,nvars])); %make sure that each variable has its own bounds


%% 5. Parameters for GA

%% 6. Optimize:
options = gaoptimset('MutationFcn',@mutationadaptfeasible, ...
                     'PopulationSize',100, ... 
                     'NonlinConAlgorithm','penalty', ...
                     'CreationFcn',@gacreationnonlinearfeasible, ...
                     'TolFun',1e-6, ...
                     'Display','iter', ...
                     'PlotFcn',@gaplotbestf, ...
                     'UseParallel',true);

[p_opt, crb_opt, exitflag, output, final_population, final_scores] = ga(cfun, nvars, A, b, Aeq, beq, lb, ub, nl_confun, options);

save('workspace_reducedUniversalGA.mat')

toc