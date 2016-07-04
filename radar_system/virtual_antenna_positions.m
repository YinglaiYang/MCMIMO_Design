function [ P_virt ] = virtual_antenna_positions( modulationParam )
%VIRTUAL_P Summary of this function goes here
%   Detailed explanation goes here

P_virt = repmat(modulationParam.P_Tx(modulationParam.pulse.Tx(:,:),:),size(modulationParam.P_Rx(modulationParam.pulse.Rx(:,:)),2),1)...
         + modulationParam.P_Rx(modulationParam.pulse.Rx(:,:),:);

end

