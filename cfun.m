function [ costVal ] = cfun( x )
% Cost function (CRB of system)
% Assumptions:
% - power identical for all frequencies
% - power identical for all antenna positions
% - p_x is centered to 0 by this function

[ p,f ] = disassembleX( x );


costVal= 1/(f'*f) / var(p,1);

end

