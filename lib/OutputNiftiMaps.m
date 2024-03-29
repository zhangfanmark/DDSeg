function OutputNiftiMaps(feature_mat_folder, mask_nii_path, output_folder)

if ~exist(fullfile(output_folder, 'ProbabilisticMap_CSF.nii.gz'), 'file')

    mask_nii = load_nii(mask_nii_path);
    img_size = size(mask_nii.img);

    mask = mask_nii.img > 0;

    segmention_prediction_3view = load(fullfile(feature_mat_folder, 'prediction', 'segmention-prediction-3views.mat')); 

    % get the segmentation maps
    prediction_categorical_map = segmention_prediction_3view.prediction_categorical_map;
    prediction_probabilistic_map_WM = segmention_prediction_3view.prediction_probabilistic_maps(:,:,:,2) ./ 100;
    prediction_probabilistic_map_GM = segmention_prediction_3view.prediction_probabilistic_maps(:,:,:,3) ./ 100;
    prediction_probabilistic_map_CSF = segmention_prediction_3view.prediction_probabilistic_maps(:,:,:,4) ./ 100;

    % Unpadding the map to its original size
    tmp_img = cat(4, prediction_categorical_map, prediction_probabilistic_map_WM, prediction_probabilistic_map_GM, prediction_probabilistic_map_CSF);
    tmp_img = padding_unpadding(tmp_img, img_size, 'unpadding');

    prediction_categorical_map = tmp_img(:, :, :, 1);
    prediction_probabilistic_map_WM = tmp_img(:, :, :, 2);
    prediction_probabilistic_map_GM = tmp_img(:, :, :, 3);
    prediction_probabilistic_map_CSF = tmp_img(:, :, :, 4);

    prediction_categorical_map(~mask) = 0;
    prediction_probabilistic_map_WM(~mask) = 0;
    prediction_probabilistic_map_GM(~mask) = 0;
    prediction_probabilistic_map_CSF(~mask) = 0;

    % output nifti images
    disp('  * output segmentation');
    mask_nii.img = single(prediction_categorical_map);
    save_nii(mask_nii, char(fullfile(output_folder, 'SegmentationMap_GMWMCSF.nii.gz')));

    disp('  * output probabilistic maps of GM, WM and CSF');

    % output is float, in case input nii type is int.
    mask_nii.hdr.dime.datatype = 16;
    mask_nii.hdr.dime.bitpix = 32;

    mask_nii.img = single(prediction_probabilistic_map_GM);
    save_nii(mask_nii, char(fullfile(output_folder, 'ProbabilisticMap_GM.nii.gz')));

    mask_nii.img = single(prediction_probabilistic_map_WM);
    save_nii(mask_nii, char(fullfile(output_folder, 'ProbabilisticMap_WM.nii.gz')));

    mask_nii.img = single(prediction_probabilistic_map_CSF);
    save_nii(mask_nii, char(fullfile(output_folder, 'ProbabilisticMap_CSF.nii.gz')));
    
else
    
    disp('  * Already Done!');
end
