
%% Initialize parameters
a.N_ant_tx = 4;
a.N_ant_rx = 4;
a.N_freq = 2;

a.p0_tx = 0;
a.p0_rx = 0;
a.f0 = 100; %[Hz] fixed frequency

nvars = (a.N_ant_tx + a.N_ant_rx - 2) + (a.N_freq - 1);
x = 1:nvars;

%% Execute code to test

% initialize `disassembleX`
disassembleX([], a);
% use `disassembleX`
[p,f] = disassembleX(x);

%% Compare results
p_ref_tx = [0,1,2,3].';
p_ref_rx = [0,4,5,6].';

p_ref = [kron(p_ref_tx, ones(a.N_ant_rx,1)) + kron(ones(a.N_ant_tx,1), p_ref_rx)];

f_ref = [100, 7].';

assert(isequal(p,p_ref), 'Position vector does not match.');
assert(isequal(f,f_ref), 'Frequency vector does not match.');

