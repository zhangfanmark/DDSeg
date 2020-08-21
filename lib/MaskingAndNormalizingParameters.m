function MaskingAndNormalizingParameters(parameter_folder, mask_file, feature_mat_folder, parameter_type)

[feature_list, feature_range] = get_feature_list(parameter_type);

brain_mask_nii = load_nii(mask_file);
brain_mask = brain_mask_nii.img > 0;

for f_idx = 1:length(feature_list)
    
    parameter_mat_file = fullfile(feature_mat_folder, [feature_list{f_idx}, '_3D_masked_normalized.mat']);
    
    parameter_range = feature_range(f_idx, :);
    
    disp([' - masking and normalizing: ', feature_list{f_idx}])
    if ~exist(parameter_mat_file, 'file')

        if strcmp(parameter_type, 'MKCurve')
            parameter_map = load_paramemter_map(fullfile(parameter_folder, [feature_list{f_idx}, '.nii.gz']));
        elseif strcmp(parameter_type, 'DTI') % We assume 3D Slicer is used for feature extraction, so nrrd files are used.
            parameter_map = load_paramemter_map(fullfile(parameter_folder, [feature_list{f_idx}, '.nrrd']));
        end

        % masking
        parameter_map(~brain_mask) = nan;

        % truncating
        parameter_map(parameter_map < parameter_range(1)) = parameter_range(1);
        parameter_map(parameter_map > parameter_range(2)) = parameter_range(2);

        % normalizing
        parameter_map_N_vec = parameter_map(brain_mask);
        parameter_map_N_vec = normalize(parameter_map_N_vec);

        parameter_map_N = nan(size(brain_mask));
        parameter_map_N(brain_mask) = parameter_map_N_vec;

        parameter_map = single(parameter_map_N);

        % save
        save(parameter_mat_file, 'parameter_map');
        
    else
        
        disp('  * Alreay done!') 
    end
    
end
