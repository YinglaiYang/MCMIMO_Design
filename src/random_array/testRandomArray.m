clc, clear, close all;

c = physconst('lightspeed');

N_ux = 1000;
N_r = 90;

seed = rng();


N_ant_tx = 4;
N_ant_rx = 4;
N_freq = 2;

f0 = 100e9;



[px,fc] = getRandomArray(N_ant_tx,N_ant_rx,N_freq-1,30,30,0.003,80e9,100e9);

ap = arrayPattern(px-mean(px),fc,N_ux,N_r);

r_max = c/(max(fc)-min(fc));

% The ROI for ux and r
ux = linspace(-1,1,N_ux);
r  = linspace(-r_max/2, r_max/2, N_r);

figure, imagesc(ux,r,ap);

figure, plot(ux,ap(1,:));

%% Create struct
env.N_ant_tx = N_ant_tx;
env.N_ant_rx = N_ant_rx;
env.N_freq = N_freq;

env.p0_tx = 0;
env.p0_rx = 0;
env.f0 = f0;


