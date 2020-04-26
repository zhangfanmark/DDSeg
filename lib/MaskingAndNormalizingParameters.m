function MaskingAndNormalizingParameters(parameter_nii_folder, feature_mat_folder, mask_file, parameter_type)

if strcmp(parameter_type, 'MKCurve')
    feature_list = {'corrected_FA', 'corrected_E1', 'corrected_E2', 'corrected_E3',...
                    'corrected_MK', 'corrected_AK', 'corrected_RK',...
                    'MKCurve_MaxMK-b0', 'MKCurve_ZeroMK-b0', 'MKCurve_MaxMK'};
end

if ~exist(feature_mat_folder, 'dir')
    mkdir(feature_mat_folder);
end

brain_mask_nii = load_nii(mask_file);
brain_mask = brain_mask_nii.img > 0;

for f_idx = 1:length(feature_list)
    
    parameter_map_nii = load_nii(fullfile(parameter_nii_folder, [feature_list{f_idx}, '.nii.gz']));
    parameter_map = parameter_map_nii.img;
    
    % masking
    parameter_map(~brain_mask) = nan;

    % normalizing
    parameter_map_N_vec = parameter_map(brain_mask);
    parameter_map_N_vec = normalize(parameter_map_N_vec);

    parameter_map_N = nan(size(brain_mask));
    parameter_map_N(brain_mask) = parameter_map_N_vec;
    
    parameter_map = single(parameter_map_N);
    
    % save
    parameter_mat_file = fullfile(feature_mat_folder, [feature_list{f_idx}, '_3D_masked_normalized.mat']);
    save(parameter_mat_file, 'parameter_map');
    
end
