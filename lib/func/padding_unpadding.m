function image_new = padding_unpadding(img, target_size, padding_or_unpadding)

image_size = size(img);

if strcmp(padding_or_unpadding, 'padding')
    % target_size will not be used for padding
    
    target_sizes = [144, 144, 96; 
                   256, 256, 96;
                   256, 256, 128;];
    
    for t_idx = 1:3
        target_size = target_sizes(t_idx, :);
        
        if sum(target_size >= image_size(1:3)) == 3
            break;
        end
    end
    
    image_new_size = target_size;

    image_new = nan([image_new_size, image_size(4)]);

    image_new(1:image_size(1), 1:image_size(2), 1:image_size(3), :) = img;
    
elseif strcmp(padding_or_unpadding, 'unpadding')
    
    image_new_size = min([image_size(1:3); target_size]);
    
    image_new = img(1:image_new_size(1), 1:image_new_size(2), 1:image_new_size(3), :);
    
end