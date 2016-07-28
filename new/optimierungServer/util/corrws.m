function [ corrval ] = corrws( A, B, w )
%CORRWS Summary of this function goes here
%   Detailed explanation goes here

corrval = B' * diag(w) * A / (ones(size(w)).' * w);

end

