function [ x_final ] = to_2d( X )
%TO_2D Converts a point in the XYZ space to a point in the 2d plane. 
%   X is a [1x3] point. 
%   X_final is a [1x2] point. 
    K = [4597.95 0      672.846
          0      4603.2  362.875
          0      0      1];
    x2d = X*K';
    x2d = x2d / x2d(3);
    x_final = x2d(1:2);
end

