function Comine3ViewPrediction(feature_mat_folder)

views = {'axial', 'sagittal', 'coronal'};

segmention_prediction_3view_mat= fullfile(feature_mat_folder, 'prediction', 'segmention-prediction-3views.mat'); 
if ~exist(segmention_prediction_3view_mat, 'file')

    prediction_probability_sum = []; % record the sum of the prediction probablity of the three views
    for v_idx = 1:length(views)
        
        view = views{v_idx};
        
        disp(['  * combine prediction: ', view]);
        
        prediction_folder = fullfile(feature_mat_folder, 'prediction', view);
        prediction_mat_files = dir(fullfile(prediction_folder, 'feat*mat'));
        
        % get prediciton image size
        tmp = load(fullfile(prediction_folder, prediction_mat_files(1).name));
        im_sz = size(tmp.allScores);
        
        % combine all prediciton images
        prediction_3Dmatrix = nan([im_sz(1), im_sz(2), length(prediction_mat_files), im_sz(3)]);
        for i_idx = 1:length(prediction_mat_files)
            prediction_mat = load(fullfile(prediction_folder, prediction_mat_files(i_idx).name));
            prediction_3Dmatrix(:, :, i_idx, :) = prediction_mat.allScores;
        end

        % reshape to the orignal 3D image
        if strcmp(view, 'sagittal')
            prediction_3Dmatrix = permute(prediction_3Dmatrix, [3, 1, 2, 4]);
        elseif strcmp(view, 'coronal')
            prediction_3Dmatrix = permute(prediction_3Dmatrix, [1, 3, 2, 4]);
        end
        
        % take the sum of prediction probablity of the three views per voxel
        if isempty(prediction_probability_sum)
            prediction_probability_sum = prediction_3Dmatrix;
        else
            prediction_probability_sum = prediction_probability_sum + prediction_3Dmatrix;
        end
    end
    
    % compute the probabilistic map per tissue type and the categorical map
    prediction_probabilistic_maps = prediction_probability_sum ./ 3 * 100;
    [~, prediction_categorical_map] = max(prediction_probabilistic_maps, [], 4);
    
    % to make the label number corresponding to the input [0, 1, 2, 3]
    prediction_categorical_map = prediction_categorical_map - 1;

    save(segmention_prediction_3view_mat, 'prediction_categorical_map', 'prediction_probabilistic_maps');
    
else
    
    disp('  * Combine 3-view predictions has done!')
end