function [ c, ceq ] = nl_constraints3( x, SLL_max, env )
%NL_CONSTRAINTS3 All the nonlinear constraints.
%   The nonlinear constraint combined in this function are:
%   1. Maximum sidelobe level
%   2. Maximum GCD
%   3. Strict ascending order: x1 < x2 < x3 < ...

[ p,f ] = disassembleX( x, env );

%% 1. Maximum sidelobe level
c1 = getSLL(p, f, SLL_max) - SLL_max; %SLLfun(x, bw) - SLL_max;

%% Last: combine constraints
c = [c1];
ceq = [];
end

