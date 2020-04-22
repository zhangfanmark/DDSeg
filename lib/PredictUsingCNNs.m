function PredictUsingCNNs(feature_mat_folder, Unet_folder)

predicted_segmentation_folder = fullfile(feature_mat_folder, 'prediction');

views = {'axial', 'sagittal', 'coronal'};
for v_idx = 1:length(views)
    
    view = views{v_idx};
    disp([' - View: ', view]);
    
    prediction_folder = fullfile(predicted_segmentation_folder, view);
    if ~exist(prediction_folder, 'dir')
        mkdir(prediction_folder);
    end
    
    if isempty(dir(fullfile(prediction_folder, '*mat')))
        
        disp('  * Loading subject-spefic images.')
        imds_subject = imageDatastore(fullfile(feature_mat_folder, 'images', view), 'FileExtensions', '.mat', 'ReadFcn', @matReader);

        disp('  * Loading the CNN model.')
        CNN_model_mat = fullfile(Unet_folder, view, 'UnetModel.mat');
        CNN_model = load(CNN_model_mat);

        disp('  * Predicting tissue segmentaion and probabilistic maps.')
        semanticseg_probability(imds_subject, CNN_model.net1, prediction_folder);
        
    else
        
        disp('  * Predicting has done!')
    end

end