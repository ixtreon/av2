function [ final_X ] = project_3d( X, r )
%PROJECT_3D Finds a point that lies r distance from X and has the same
%magnitude. 
%   X is a [1x3] point. 
    d = norm(X);
    
    
    angXY = atan2(X(2), X(1));
    angXZ = atan2(X(3), X(1));
    
    r2 = r * sin(angXY);
    
    a = acos(1 - (r2*r2) / (2*d*d));
    
    out_X = [1, tan(angXY), 0];
    n = norm(out_X);
    out_X = out_X / n;
    out_X(3) = tan(angXZ + a);
    
    
    % out_X = sign(X(1)) * [1, tan(angXY), tan(angXZ + a)];
    
    final_X = out_X ./ norm(out_X) .* d;
    
    d = norm(final_X - X);
    f = d / r;
end

