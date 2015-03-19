function [ g ] = grav( ps, t )
%GRAV Summary of this function goes here
%   Detailed explanation goes here
    g = 0;
    for i = 1:t
        g = g + get_g(ps, t);
    end
    g = g / t;
end


function [g] = get_g(ps, t)
    g = - (t - 1) * (ps(t) - ps(t-1)) / (t * t);
    
end

