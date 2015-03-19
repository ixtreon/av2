function mask = get_mask( img, last_img)
%MASK Gets a 2D mask of the moving ball. 
%   Detailed explanation goes here
    mask_thresh = 0.01;
    open_sz = 3;
    
    d = abs(img - last_img);
    mask = im2bw(d, mask_thresh);
    
    mask = imopen(mask, strel('disk', open_sz));
    mask = imclose(mask, strel('disk', 20));
end

