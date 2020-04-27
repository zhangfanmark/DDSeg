addpath(genpath('lib'));

%% example to run tissue segmentation using DTI parameters

input_nii_file      = 'test/test_sub_HCP/HCP-100337.nii.gz';
input_bval_file     = 'test/test_sub_HCP/HCP-100337.bvals';
input_bvec_file     = 'test/test_sub_HCP/HCP-100337.bvecs';
input_mask_nii_file = 'test/test_sub_HCP/HCP-100337_nodif_brain_mask.nii.gz';

MKCurve_folder  = 'test/test_sub_HCP/MKCurve';
if ~exist(MKCurve_folder, 'dir')
    mkdir(MKCurve_folder)
end

% Run MKCurve feature extraction.
% Please configure module paths of 3D Slicer in the `run_DTI_feature_extraction_3DSlicer`
run_MKCurve_feature_extraction(input_nii_file, input_bval_file, input_bvec_file, input_mask_nii_file, MKCurve_folder)


% Run tissue segmentaion prediction
input_feature_img_folder = fullfile(MKCurve_folder, 'out/threshold_0.50/corrected_nii/');
parameter_type           = 'MKCurve';
output_folder            = 'test/test_sub_HCP/MKCurveSeg';

run_DeepDWITissueSegmentation(input_feature_img_folder, input_mask_nii_file, parameter_type, output_folder);