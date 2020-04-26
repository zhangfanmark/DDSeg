function image_new = padding_unpadding(img, target_size, padding_or_unpadding)

image_size = size(img);

if strcmp(padding_or_unpadding, 'padding')
    image_new_size = max([image_size(1:3); target_size]);

    image_new = nan([image_new_size, image_size(4)]);

    image_new(1:image_size(1), 1:image_size(2), 1:image_size(3), :) = img;
    
elseif strcmp(padding_or_unpadding, 'unpadding')
    
    image_new_size = min([image_size(1:3); target_size]);
    
    image_new = img(1:image_new_size(1), 1:image_new_size(2), 1:image_new_size(3), :);
    
end