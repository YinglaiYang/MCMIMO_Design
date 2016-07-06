function [ wsmeanval ] = ews( A, w )
%EWS Summary of this function goes here
%   Detailed explanation goes here

wsmeanval = w.' * A / (ones(size(w)).' * w);

end

