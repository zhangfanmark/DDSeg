function run_DeepDWITissueSegmentation(input_feature_img_folder, input_mask_nii_file, parameter_type, output_folder)

disp(' ')
disp('====================================================');
disp('======  **  Deep DWI tissue segmentation  **  ======');

feature_mat_folder = fullfile(output_folder, [parameter_type 'Parameters']);
if ~exist(feature_mat_folder, 'dir')
    mkdir(feature_mat_folder);
end

disp(' ')
disp('=== 1. Masking and normalizing input parameters ===')
MaskingAndNormalizingParameters(input_feature_img_folder, input_mask_nii_file, feature_mat_folder,  parameter_type);

disp(' ')
disp('=== 2. Separate 3D feature volume  ===');
SeparateInto3ViewImages(feature_mat_folder, parameter_type);

disp(' ')
disp('=== 3. CNN segmentation prediction ===');
PredictUsingCNNs(feature_mat_folder, parameter_type);

disp(' ')
disp('=== 4. Combine three-view segmentation ===');
Comine3ViewPrediction(feature_mat_folder);

disp(' ')
disp('=== 5. Output segmentation results ===');
OutputNiftiMaps(feature_mat_folder, input_mask_nii_file);

