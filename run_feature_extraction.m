function run_feature_extraction(nii_file, bval_file, bvec_file, mask_file, MKCurve_folder)

%% Run MK-Curve code:
disp(' ')
disp('=== 1. Run MK-Curve feature extraction ===')
MKCurve_parameter_mat = fullfile(MKCurve_folder, 'out', 'threshold_0.50', 'corrected_nii', 'MKCurve_MaxMK.nii.gz');
if ~exist(MKCurve_parameter_mat, 'file')
    MKCurve_code = '~/Desktop/MK-Curve';
    addpath(genpath(MKCurve_code));
    run_MKCurve(nii_file, bval_file, bvec_file, mask_file, MKCurve_folder, 1);
    rmpath(genpath(MKCurve_code));
else
    disp('  * Already done!')
end

%% Masking and normalizing
disp(' ')
disp('=== 2. Masking and normalizing parameters ===')
MKCurve_parameter_nii_folder = fullfile(MKCurve_folder, 'out', 'threshold_0.50', 'corrected_nii');
feature_mat_folder = fullfile('./test/Shanghai_Ndyx266/MKCurveParameters');
if ~exist(fullfile(feature_mat_folder, 'MKCurve_MaxMK_3D_masked_normalized.mat'), 'file')
    MaskingAndNormalizingParameters(MKCurve_parameter_nii_folder, feature_mat_folder, mask_file, 'MKCurve');
else
    disp('  * Already done!')
end
