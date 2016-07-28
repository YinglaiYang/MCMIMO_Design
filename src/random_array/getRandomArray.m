function [ px, fc ] = getRandomArray( M, N, C, M_grid, N_grid, d_grid, f_min, f_max )
%GETRANDOMARRAY Summary of this function goes here
%   Detailed explanation goes here

% Select M or N antennas, respectively from the grids
array_pos_tx = randperm(M_grid,M);
array_pos_rx = randperm(N_grid,N);

% Create physical array
array_tx = [array_pos_tx * d_grid].';
array_rx = [array_pos_rx * d_grid].';

% MIMO virtual array
px = [kron(array_tx, ones(N,1)) + kron(ones(M,1), array_rx)];

% Select random frequencies
fc = randi([f_min,f_max],[C,1]);

end

