function [ kappa ] = getKappa( SNR_dB )
%GETKAPPA Summary of this function goes here
%   Detailed explanation goes here
c = physconst('Lightspeed');

kappa = 0.5 * (10^(SNR_dB)/10)^-1 * c/(2*pi)^2

end

