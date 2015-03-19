
data_dir = 'dataset/';

% load the dataset
data_files = dir([data_dir, '*.mat']);
n_files = size(data_files, 1);

% start drawing
figure(1);
last_img = importdata([data_dir, data_files(1).name]);
last_img = last_img.Img;

% sphere tracking
sphere_pos = zeros([n_files, 3]);

for i = 1 : n_files
    
    % load the current file and its data
    f = data_files(i);
    data = importdata([data_dir, f.name]);
    
    [w, h] = size(data.Img);
    % zs visualises the stereo depth data
%     zs = data.XYZ(:,:,3);
%     min_z = 1.0;
%     max_z = 1.5;
%     zs = (zs - min_z) ./ (max_z - min_z);
    
    % get the 2d mask using the image data
    mask = get_mask(data.Img, last_img);
    
    intensity_img = (sqrt(sum(data.XYZ.^2, 3)) - 0.8);
    
    figure(1);
    imshow([data.Img, intensity_img; (data.Img + mask) ./ 2, mask]);
    
    hold on;
    
    if any(any(mask))
        % grab the 3d position for pixels in the mask
        xyz = reshape(data.XYZ, [w*h, 3]);
        
        % get the linear indices of the ones in the mask
        xs = xyz(mask, :);
        
        
        % pass them to the RANSAC algorithm
        [o, r, n_good] = ransac(xs);
        
        
        % convert the 2d to 3d
        sphere_center = to_2d(o);
        sphere_pos(i,:) = o;
        
        o2 = project_3d(o, r);
        sphere_rad = sqrt(sum((to_2d(o2) - sphere_center) .^ 2));
        
        % show the sphere radius
        xyz_center = bsxfun(@minus, xyz, o);
        xyz_dist = sqrt(sum(xyz_center.^2,2));
        
        % plot the detected sphere
        plot(sphere_center(1), sphere_center(2), 'r.', 'MarkerSize', 10);
        plot(sphere_center(1), sphere_center(2), 'ro', 'MarkerSize', sphere_rad / 2);
        
        G = grav(sphere_pos(:, 3), i)
    end
    
    %waitforbuttonpress();
    
    
    
    hold off;
    
    last_img = data.Img;
end
