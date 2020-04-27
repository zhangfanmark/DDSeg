addpath(genpath('lib'));

%% example to run tissue segmentation using DTI parameters

input_nii_file      = 'test/test_sub_CAP/CAP-dwi.nii.gz';
input_bval_file     = 'test/test_sub_CAP/CAP-dwi.bval';
input_bvec_file     = 'test/test_sub_CAP/CAP-dwi.bvec';
input_mask_nii_file = 'test/test_sub_CAP/CAP_brain_mask.nii.gz';

DTI_ouput_folder  = 'test/test_sub_CAP/DTI';
if ~exist(DTI_ouput_folder, 'dir')
    mkdir(DTI_ouput_folder)
end


% DTI parameter is better on single shell data, so here we extract only
% b=1000 data; There NO NEED to run this if single shell data is provided.
out_nii_file    = 'test/test_sub_CAP/DTI/CAP-dwi-b1000.nii.gz';
out_bval_file   = 'test/test_sub_CAP/DTI/CAP-dwi-b1000.bval';
out_bvec_file   = 'test/test_sub_CAP/DTI/CAP-dwi-b1000.bvec';

removed_bvals = [1:999,1001:4000];
extract_DWI_shells(input_nii_file, input_bval_file, input_bvec_file, removed_bvals, out_nii_file, out_bval_file, out_bvec_file);


% Run DTI feature extraction.
% Please configure module paths of 3D Slicer in the `run_DTI_feature_extraction_3DSlicer`
run_DTI_feature_extraction_3DSlicer(out_nii_file, out_bval_file, out_bvec_file, DTI_ouput_folder);


% Run tissue segmentaion prediction
input_feature_img_folder = DTI_ouput_folder;
parameter_type           = 'DTI';
output_folder            = 'test/test_sub_CAP/DTISeg';

run_DeepDWITissueSegmentation(input_feature_img_folder, input_mask_nii_file, parameter_type, output_folder);