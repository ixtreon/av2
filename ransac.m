function [ o, r, good_pts ] = ransac( xs )
%RANSAC Performs the RANSAC algorithm for the list of points xs. 
%   Detailed explanation goes here
    n_pts = length(xs);
    n_trials = 50;
    n_picks = 5;
    n_good_req = 0.9;
    match_dist = 0.02;
    
    o = [1 1];
    r = 1;
    
    % alg from the ransac slides
    for i = 1 : n_trials
        T = random_pick(xs, n_picks);
        [center, rad] = fit_model(T);
        
        good_pts = get_matching(xs, center, rad, match_dist);
        n_good = length(good_pts);
        if n_good / n_good_req > n_pts
            o = center;
            r = rad;
            return;
        end
    end
end

% picks n random points from xs without repetition. 
function pts = random_pick(xs, n)
    pts = datasample(xs, n, 'Replace', true);
end

% Fits a sphere to the given sample of points. 
function [o, r] = fit_model(X)
    % Input:
    % X: n x 3 matrix of cartesian data
    % Outputs:
    % Center: Center of sphere 
    % Radius: Radius of sphere
    % Author:
    % Alan Jennings, University of Dayton

    A=[
        mean(X(:,1) .* (X(:,1)-mean(X(:,1)))), ...
        2*mean(X(:,1).*(X(:,2)-mean(X(:,2)))), ...
        2*mean(X(:,1).*(X(:,3)-mean(X(:,3)))); ...
        0, ...
        mean(X(:,2).*(X(:,2)-mean(X(:,2)))), ...
        2*mean(X(:,2).*(X(:,3)-mean(X(:,3)))); ...
        0, ...
        0, ...
        mean(X(:,3).*(X(:,3)-mean(X(:,3))))];
    A=A+A.';
    
    B=[mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,1)-mean(X(:,1))));...
        mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,2)-mean(X(:,2))));...
        mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,3)-mean(X(:,3))))];
    o=(A\B).';
    r=sqrt(mean(sum([X(:,1)-o(1),X(:,2)-o(2),X(:,3)-o(3)].^2,2)));
end

% Gets the points in xs which are at most d distance from the
% boundary of the sphere. 
function pts = get_matching(xs, o, r, d)
    % TODO: write this up
    n_pts = size(xs, 1);
    
    ds = xs - ones(n_pts, 1) * o;
    ds = sqrt(sum(ds .^ 2, 2));
    ds = abs(ds - r);
    pts = xs(ds < d);
end