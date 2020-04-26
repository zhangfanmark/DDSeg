function SeparateInto3ViewImages(feature_mat_folder, parameter_type)

% Get the feature list
feature_list = get_feature_list(parameter_type);

% Prepare output folders
separated_images_folder = fullfile(feature_mat_folder, 'images');
if isempty(dir(fullfile(separated_images_folder, 'coronal', 'feat-*mat')))
    
    % Create ouput folders
    if ~exist(fullfile(separated_images_folder, 'axial'), 'dir')
        mkdir(fullfile(separated_images_folder, 'axial'));
    end
    if ~exist(fullfile(separated_images_folder, 'sagittal'), 'dir')
        mkdir(fullfile(separated_images_folder, 'sagittal'));
    end
    if ~exist(fullfile(separated_images_folder, 'coronal'), 'dir')
        mkdir(fullfile(separated_images_folder, 'coronal'));
    end

    % Extract X features
    x_feature = [];
    for f_idx = 1:length(feature_list)
        mat = load(fullfile(feature_mat_folder, [feature_list{f_idx}, '_3D_masked_normalized.mat']));
        x_feature(:, :, :, f_idx) = mat.parameter_map;
    end
    
    % Training image size is [112, 144, 96]
    x_feature = padding_unpadding(x_feature, [112, 144, 96], 'padding');
    
    % Backgroud voxels to -100
    x_feature(isnan(x_feature))= -100;

    % output image mat files
    disp('  * output image mat files: axial');
    for i = 1:size(x_feature, 3)
        x = squeeze(x_feature(:,:,i,:));
        save(fullfile(separated_images_folder, 'axial', ['feat-axial-', num2str(i, '%03d'),'.mat']),'x')
    end
    
    disp('  * output image mat files: coronal');
    for i = 1:size(x_feature, 2)
        x = squeeze(x_feature(:,i,:,:));
        save(fullfile(separated_images_folder, 'coronal', ['feat-coronal-', num2str(i, '%03d'),'.mat']),'x')
    end

    disp('  * output image mat files: sagittal');
    for i = 1:size(x_feature,1)
        x = squeeze(x_feature(i,:,:,:));
        save(fullfile(separated_images_folder, 'sagittal', ['feat-sagittal-', num2str(i, '%03d'),'.mat']),'x')
    end

else
    
    disp('  * image feature mat has been created.') 
end
