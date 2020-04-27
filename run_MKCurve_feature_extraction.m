function run_MKCurve_feature_extraction(nii_file, bval_file, bvec_file, mask_file, MKCurve_folder)


%% Run MK-Curve code
% The code need Nifti DWI

% Change paths to the MK-Curve code
MKCurve_code = '~/Desktop/MK-Curve';
 
disp(' ')
disp('=== Run MK-Curve feature extraction ===')
MKCurve_parameter_mat = fullfile(MKCurve_folder, 'out', 'threshold_0.50', 'corrected_nii', 'MKCurve_MaxMK.nii.gz');
if ~exist(MKCurve_parameter_mat, 'file')
   
    addpath(genpath(MKCurve_code));
    run_MKCurve(nii_file, bval_file, bvec_file, mask_file, MKCurve_folder, 1);
    rmpath(genpath(MKCurve_code));
    
else
    disp('  * Already done!')
end
