function [ g ] = grav( ps, t )
%GRAV Summary of this function goes here
%   Detailed explanation goes here

    vs = ps - [ps(2:end); 0];
    vs = vs(1:end);
    
    g = 0;
    for i = 2:t
        g = g + get_g(ps, t);
    end
    g = g / (t-1);
end


function [g] = get_g(ps, t)
    g = - (t - 1) * (ps(t) - ps(t-1)) / (t * t);
end

