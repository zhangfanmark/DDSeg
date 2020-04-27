addpath(genpath('lib'));

%% example to run tissue segmentation using DTI parameters

input_nii_file      = 'test/test_sub_CAP/CAP-dwi.nii.gz';
input_bval_file     = 'test/test_sub_CAP/CAP-dwi.bval';
input_bvec_file     = 'test/test_sub_CAP/CAP-dwi.bvec';
input_mask_nii_file = 'test/test_sub_CAP/CAP_brain_mask.nii.gz';

MKCurve_folder  = 'test/test_sub_CAP/MKCurve';
if ~exist(MKCurve_folder, 'dir')
    mkdir(MKCurve_folder)
end

% DTI parameter is better on high-b multi shell DWI, so here we extract only
% b=1000, 3000 data.
out_nii_file    = 'test/test_sub_CAP/MKCurve/CAP-dwi-b1000-b3000.nii.gz';
out_bval_file   = 'test/test_sub_CAP/MKCurve/CAP-dwi-b1000-b3000.bval';
out_bvec_file   = 'test/test_sub_CAP/MKCurve/CAP-dwi-b1000-b3000.bvec';

removed_bvals = [1:999,3001:4000];
extract_DWI_shells(input_nii_file, input_bval_file, input_bvec_file, removed_bvals, out_nii_file, out_bval_file, out_bvec_file);


% Run MKCurve feature extraction.
% Please configure module paths of 3D Slicer in the `run_DTI_feature_extraction_3DSlicer`
run_MKCurve_feature_extraction(out_nii_file, out_bval_file, out_bvec_file, input_mask_nii_file, MKCurve_folder)


% Run tissue segmentaion prediction
input_feature_img_folder = fullfile(MKCurve_folder, 'out/threshold_0.50/corrected_nii/');
parameter_type           = 'MKCurve';
output_folder            = 'test/test_sub_CAP/MKCurveSeg';

run_DeepDWITissueSegmentation(input_feature_img_folder, input_mask_nii_file, parameter_type, output_folder);