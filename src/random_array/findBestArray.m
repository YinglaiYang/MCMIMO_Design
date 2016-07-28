clc, clear, close all;

seed = rng();

%% Parameters
c = physconst('lightspeed');

N_ant_tx = 4;
N_ant_rx = 4;
N_freq = 2;

maxSLL = 0.2;

%% Cycle through and look for best one
N_cycles = 10000;

best.cfval = Inf;
best.sll = 1;
best.px = [];
best.fc = [];

best_cfv.cfval = Inf;
best_cfv.sll   = 1;
best_cfv.px    = [];
best_cfv.fc    = [];

best_sll.cfval = Inf;
best_sll.sll   = 1;
best_sll.px    = [];
best_sll.fc    = [];


for n=1:N_cycles
    [px,fc] = getRandomArray(N_ant_tx,N_ant_rx,N_freq,30,30,0.003,80e9,100e9);

    sll = getSLL(px,fc,maxSLL);
    cfval = cfun_pf(px,fc);
    
    % Is the constraint fulfilled
    if sll <= maxSLL
        % Is it better than the best until now?
        if cfval < best.cfval
            best.cfval = cfval;
            best.px = px;
            best.fc = fc;
            best.sll = sll;
        end
    end
    
    if cfval < best_cfv.cfval
        best_cfv.cfval = cfval;
        best_cfv.sll   = sll;
        best_cfv.px    = px;
        best_cfv.fc    = fc;
    end
    
    if sll < best_sll.sll
        best_sll.cfval = cfval;
        best_sll.sll   = sll;
        best_sll.px    = px;
        best_sll.fc    = fc;
    end
    
    if mod(n,100) == 0
        fprintf('Finished cycle number %i\n', n);
    end
end

if ~isempty(best.px)
    fprintf('\n\nA solution was found.\n');
else
    fprintf('\n\nNo solution fulfilled the constraint.\n');
end




