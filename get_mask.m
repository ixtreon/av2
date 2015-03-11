function mask = get_mask( img, last_img)
%MASK Gets a 2D mask of the moving ball. 
%   Detailed explanation goes here
    thresh = 0.01;
    open_sz = 3;
    
    d = abs(img - last_img);
    mask = im2bw(d, thresh);
    %mask = im2bw(d, graythresh(d));
    mask = imopen(mask, strel('disk', open_sz));
%     mask = imdilate(mask, strel('disk', 70));
%     mask = imerode(mask, strel('disk', 75));
end

