function [ cfval ] = cfun_pf( px, fc )
%CFUN_RANDOM Summary of this function goes here
%   Detailed explanation goes here

cfval = 1/(fc'*fc) / var(px,1) * 1e9;

end

