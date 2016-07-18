N_ux = 361;
N_r  = 91;

%% First load any data.
[px,fc] = disassembleX(p_opt,env);
ap = arrayPattern(px-mean(px),fc,N_ux,N_r);

r_max = c/(max(fc)-min(fc));

% The ROI for ux and r
ux = linspace(-1,1,N_ux);
r  = linspace(-r_max/2, r_max/2, N_r);

figure, imagesc(ux,r,ap);