function [ o, r ] = ransac( xs )
%RANSAC Performs the RANSAC algorithm for the list of points xs. 
%   Detailed explanation goes here
    n_trials = 10;
    n_picks = 5;
    n_good_req = 40000;
    match_dist = 0.01;
    
    % alg from the ransac slides
    for i = 1 : n_trials
        T = random_pick(xs, n_picks);
        [o, r] = fit_model(T);
        n_good = get_matching(xs, o, r, match_dist);
        if n_good >= n_good_req
            return
        end
    end
end

% picks n random points from xs without repetition. 
function pts = random_pick(xs, n)
    pts = datasample(xs, n, 'Replace', true);
end

% Fits a sphere to the given sample of points. 
function [o, r] = fit_model(xs)
    n_pts = size(xs, 1);
    
    % the center is the mean of the points
    o = sum(xs, 1) / n_pts;
    
    % the radius is the average distance from the center 
    % TODO: this minimizes MAE not MSE
    os = repmat(o, [n_pts, 1]);
    rs = sqrt(sum((xs - os).^2, 2));
    r = sum(rs, 1) / n_pts;
end

% Gets the points in xs which are at most d distance from the
% boundary of the sphere. 
function n_pts = get_matching(xs, o, r, d)
    % TODO: write this up
    n_pts = size(xs, 1);
    
    ds = xs - ones(n_pts, 1) * o;
    ds = sqrt(sum(ds .^ 2, 2));
    ds = ds - ones(n_pts, 1) * r;
    ds = abs(ds);
    n_pts = length(xs(ds < d));
end