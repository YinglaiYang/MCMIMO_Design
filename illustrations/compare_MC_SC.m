clc, clear, close all;

N_ux = 1024;
N_r  = 91;

SNR_dB = 10;

kappa = getKappa(SNR_dB);

%% First load any data.
mc = load('/Users/yinglai/GitHub/MCMIMO_Design/results/21-07-2016/MC_workspace_reducedUniversalGA_MC.mat');
sc = load('/Users/yinglai/GitHub/MCMIMO_Design/results/21-07-2016/SC_workspace_reducedUniversalGA_SC.mat');

% MC
[mc.px,mc.fc] = disassembleX(mc.p_opt,mc.env);
mc.px=(mc.px-mean(mc.px))*1.1;
mc.ap = arrayPattern(mc.px-mean(mc.px),mc.fc,N_ux,N_r);

r_max = mc.c/(max(mc.fc)-min(mc.fc));

% The ROI for ux and r
ux = linspace(-1,1,N_ux);
r  = linspace(-0.5,0.5, N_r);

figure, imagesc(ux,r,mc.ap);

figure, plot(ux,mc.ap(1,:));

CRB_mc = kappa * cfun_pf(mc.px,mc.fc)
sll_mc = getSLL(mc.px,mc.fc,0.2)

% SC
[sc.px,sc.fc] = disassembleX(sc.p_opt,sc.env);
sc.px=(sc.px-mean(sc.px))*1.0;
%sc.fc=[sc.fc;sc.fc];
sc.ap = arrayPattern(sc.px-mean(sc.px),sc.fc,N_ux,1);

figure, plot(ux,sc.ap);

CRB_sc = kappa * cfun_pf(sc.px,sc.fc) /2
sll_sc = getSLL(sc.px,sc.fc,0.2)

%% Combination
figure, plot(ux,mc.ap(1,:), ux,sc.ap);