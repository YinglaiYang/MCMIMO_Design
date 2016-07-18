clc, clear, close all;

N_ux = 1024;
N_r  = 91;

%% First load any data.
mc = load('/Users/yinglai/GitHub/MCMIMO_Design/results/15-07-2016/01_workspace_reducedUniversalGA.mat');
sc = load('/Users/yinglai/GitHub/MCMIMO_Design/results/15-07-2016/02_workspace_reducedUniversalGA_SC.mat');

% MC
[px,fc] = disassembleX(mc.p_opt,mc.env);
ap = arrayPattern(px-mean(px),fc,N_ux,N_r);

r_max = mc.c/(max(fc)-min(fc));

% The ROI for ux and r
ux = linspace(-1,1,N_ux);
r  = linspace(-r_max/2, r_max/2, N_r);

figure, imagesc(ux,r,ap);

figure, plot(ux,ap(1,:));

% SC
[px,fc] = disassembleX(sc.p_opt,sc.env);
ap = arrayPattern(px-mean(px),fc,N_ux,1);

figure, plot(ux,ap);
