function [ final_X ] = project_3d( X, r )
%PROJECT_3D Finds a point that lies r distance from X and has the same
%magnitude. 
%   X is a [1x3] point. 
    d = norm(X);
    
    a = acos(1 - (r*r) / (2*d*d));
    
    angXY = atan2(X(2), X(1));
    angXZ = atan2(X(3), X(1));
    
    xy = sign(X(1)) * [1, tan(angXY)];
    
    out_X = sign(X(1)) * [1, tan(angXY), tan(angXZ + a)];
    
    final_X = out_X ./ norm(out_X) .* d;
    
    d = norm(final_X - X);
    f = d / r;
end

