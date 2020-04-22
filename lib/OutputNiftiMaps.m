function OutputNiftiMaps(feature_mat_folder, mask_nii_path)

mask_nii = load_nii(mask_nii_path);
img_size = size(mask_nii.img);

segmention_prediction_3view = load(fullfile(feature_mat_folder, 'prediction', 'segmention-prediction-3views.mat')); 

% get the segmentation maps
prediction_categorical_map = segmention_prediction_3view.prediction_categorical_map;
prediction_probabilistic_map_WM = segmention_prediction_3view.prediction_probabilistic_maps(:,:,:,2) ./ 100;
prediction_probabilistic_map_GM = segmention_prediction_3view.prediction_probabilistic_maps(:,:,:,3) ./ 100;
prediction_probabilistic_map_CSF = segmention_prediction_3view.prediction_probabilistic_maps(:,:,:,4) ./ 100;

% TODO: reshape to their original size
tmp_img = nan(img_size);
tmp_img(17:128, 17:160, 19:114) = prediction_categorical_map;
prediction_categorical_map = tmp_img;

tmp_img = nan(img_size);
tmp_img(17:128, 17:160, 19:114) = prediction_probabilistic_map_GM;
prediction_probabilistic_map_GM = tmp_img;

tmp_img = nan(img_size);
tmp_img(17:128, 17:160, 19:114) = prediction_probabilistic_map_WM;
prediction_probabilistic_map_WM = tmp_img;

tmp_img = nan(img_size);
tmp_img(17:128, 17:160, 19:114) = prediction_probabilistic_map_CSF;
prediction_probabilistic_map_CSF = tmp_img;

% output nifti images
disp('  * output segmentation');
mask_nii.img = single(prediction_categorical_map);
save_nii(mask_nii, char(fullfile(feature_mat_folder, 'prediction', 'SegmentationMap_GMWMCSF.nii.gz')));

disp('  * output probabilistic maps of GM, WM and CSF');
mask_nii.img = single(prediction_probabilistic_map_GM);
save_nii(mask_nii, char(fullfile(feature_mat_folder, 'prediction', 'ProbabilisticMap_GM.nii.gz')));

mask_nii.img = single(prediction_probabilistic_map_WM);
save_nii(mask_nii, char(fullfile(feature_mat_folder, 'prediction', 'ProbabilisticMap_WM.nii.gz')));

mask_nii.img = single(prediction_probabilistic_map_CSF);
save_nii(mask_nii, char(fullfile(feature_mat_folder, 'prediction', 'ProbabilisticMap_CSF.nii.gz')));
