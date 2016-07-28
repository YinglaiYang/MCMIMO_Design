function [ costVal ] = cfun_template( x, env )
% Cost function (CRB of system)
% Assumptions:
% - power identical for all frequencies
% - power identical for all antenna positions
% - p_x is centered to 0 by this function

[ p,f ] = disassembleX( x, env );

d_inv=f/3e8;
p=p-mean(mean(p));

costVal= 1/(d_inv'*d_inv) / var(p,1) *1e4;

end

