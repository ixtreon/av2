
data_dir = 'dataset/';

% load the dataset
data_files = dir([data_dir, '*.mat']);
n_files = size(data_files, 1);

% init the drawing
figure(1);
last_img = importdata([data_dir, data_files(1).name]);
last_img = last_img.Img;

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
    
    for i = 750:1200
       mask(:,i) = 0; 
    end
    
    figure(1);
    imshow([data.Img, mask; (data.Img + mask) ./ 2, mask]);
    
    hold on;
    
    if any(any(mask))
        % grab the 3d position for pixels in the mask
        xyz = reshape(data.XYZ, [w*h, 3]);
        
        % get the linear indices of the ones in the mask
        xs = xyz(mask, :);
        
        length(mask(mask > 0))
        
        % pass them to the RANSAC algorithm
        [o, r, n_good] = ransac(xs);
        
        % plot the detected thing
        plot(o(1), o(2), 'r.', 'MarkerSize', 10);
        plot(o(1), o(2), 'ro', 'MarkerSize', r);
    end
    
    
    
    
    
    hold off;
    
    last_img = data.Img;
end
