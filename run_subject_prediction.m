function run_subject_prediction(subject_data_folder, parameter_type)

if strcmp(parameter_type, 'DTI')
    feature_mat_folder = fullfile(subject_data_folder, 'DTIParameters');
    feature_list = {'DTI_fa', 'DTI_md', 'DTI_e1', 'DTI_e2', 'DTI_e3'};
    Unet_folder = fullfile('CNN-models', 'Unet-DTI-n5-ATloss-GMWMCSF');
    mask_nii_path = fullfile(subject_data_folder, 'BrainMask.nii.gz');
end

disp(' ')
disp('=== 1. Separate 3D feature volume  ===');
SeparateInto3ViewImages(feature_mat_folder, feature_list);

disp(' ')
disp('=== 2. CNN segmentation prediction ===');
PredictUsingCNNs(feature_mat_folder, Unet_folder);

disp(' ')
disp('=== 3. Combine three-view segmentation ===');
Comine3ViewPrediction(feature_mat_folder);

disp(' ')
disp('=== 4. Output segmentation results ===');
OutputNiftiMaps(feature_mat_folder, mask_nii_path);

