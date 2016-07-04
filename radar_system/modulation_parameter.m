function [ mp ] = modulation_parameter( pulse_sequence_fn, P_Tx_fn, P_Rx_fn )
%MODULATIONPARAMETER Summary of this function goes here
%   Detailed explanation goes here

mp.pulse = pulse_sequence_fn(); %pulse_sequence needs to be able to fill:
                                % Tx, Rx, fc, t_slow
mp.P_Tx = P_Tx_fn();

mp.P_Rx = P_Rx_fn();

end