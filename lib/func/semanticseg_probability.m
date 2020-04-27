function semanticseg_probability(imds_subject, net1, prediction_folder)

fprintf('  * predicting segmentation per image : 000');
for i_idx = 1:length(imds_subject.Files)
    
   fprintf('\b\b\b');
   fprintf('%s%%', num2str(round(i_idx/length(imds_subject.Files)*100), '%02d'))
        
   imd_path = imds_subject.Files{i_idx};
   [~,imd_name,~] = fileparts(imd_path);
    
   try
        gpuDevice;
   catch
        warning('no GPU avaiable, thus using CPU.');
   end
   
   I = load(imd_path);
   [C, score, allScores] = semanticseg(I.x, net1);
   
   prob_mat_path = fullfile(prediction_folder, [imd_name, '.mat']);
   save(prob_mat_path, 'C', 'score', 'allScores');
   
end
fprintf('\n')
