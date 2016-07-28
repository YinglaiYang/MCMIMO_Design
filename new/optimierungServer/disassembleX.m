function [ p,f ] = disassembleX( x, env )
%DISASSEMBLEX Summary of this function goes here
%   Detailed explanation goes here

%% Initialize values for later use
% Load the values for the number of antennas and carrier frequencies
N_ant_tx = env.N_ant_tx;
N_ant_rx = env.N_ant_rx;
N_ant = N_ant_tx + N_ant_rx;
N_freq = env.N_freq;

% Load the values for the fixed parameters
p0_tx = env.p0_tx;
p0_rx = env.p0_rx;
f0 = env.f0;

% Total number of free variables == number of chromosomes == length(x) 
nvars = (N_ant - 2) + (N_freq - 1); %Two fixed antennas (one for TX and one for RX) as well as one fixed frequency

% The indices of the tx and rx antennas as well as the frequencies
pos_ind_tx = 1                 : N_ant_tx-1;    % [0, x(pos_ind_tx)] -> px_tx
pos_ind_rx = pos_ind_tx(end)+1 : N_ant-2;       % [0, x(pos_ind_rx)] -> px_rx
freq_ind   = pos_ind_rx(end)+1 : nvars;         % [f0, x(freq_ind)] -> f

%% Disassemble the chromosomes
p_tx = [p0_tx, x(pos_ind_tx)].';
p_rx = [p0_rx, x(pos_ind_rx)].';

p = [kron(p_tx, ones(N_ant_rx,1)) + kron(ones(N_ant_tx,1), p_rx)]; % combined MIMO array
f = [f0, x(freq_ind)].'; % carrier frequencies

end

