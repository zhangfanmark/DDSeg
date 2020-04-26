function run_subject_prediction(feature_mat_folder, mask_nii_path, parameter_type)

%
disp(' ')
disp('=== 1. Separate 3D feature volume  ===');
SeparateInto3ViewImages(feature_mat_folder, parameter_type);

disp(' ')
disp('=== 2. CNN segmentation prediction ===');
PredictUsingCNNs(feature_mat_folder, parameter_type);

disp(' ')
disp('=== 3. Combine three-view segmentation ===');
Comine3ViewPrediction(feature_mat_folder);

disp(' ')
disp('=== 4. Output segmentation results ===');
OutputNiftiMaps(feature_mat_folder, mask_nii_path);

