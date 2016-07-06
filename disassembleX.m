function [ p,f ] = disassembleX( x )
%DISASSEMBLEX Summary of this function goes here
%   Detailed explanation goes here

N_ant_tx = 4; M = N_ant_tx;
N_ant_rx = 4; N = N_ant_rx;

N_ant = N_ant_tx + N_ant_rx;
nvars = N_ant; %N_ant - 1 positional variables + 1 freq

f0 = 80e9; %[Hz] fixed frequency

pos_ind_tx = 1:N_ant_tx-1;   % [0, x(pos_ind_tx)] -> px_tx
pos_ind_rx = N_ant_tx:N_ant - 2; % [0, x(pos_ind_rx)] -> px_rx
freq_ind = nvars;      % [f0, x(freq_ind)] -> f

p0_tx = 0; % First antenna is fixed!
p0_rx = 0;



%%
p_tx = [p0_tx, x(pos_ind_tx)].';
p_rx = [p0_rx, x(pos_ind_rx)].';
p = [kron(p_tx, ones(N,1)) + kron(ones(M,1), p_rx)];
f = [f0, x(freq_ind)].';
end

