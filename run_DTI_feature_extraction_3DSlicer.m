function run_DTI_feature_extraction_3DSlicer(nii_file, bval_file, bvec_file, ouput_folder)


%% Run DTI feature extraction using 3D Slicer
% The code assume you have Nifti DWI

% Change paths to the CLI module
SlicerBase = '/Applications/Slicer4p10realease.app/Contents';
Slicer_DWIConvert_cli = fullfile(SlicerBase, 'lib/Slicer-4.10/cli-modules/DWIConvert');
Slicer_DWIToDTIEstimation_cli = fullfile(SlicerBase, 'Extensions-27501/SlicerDMRI/lib/Slicer-4.10/cli-modules/DWIToDTIEstimation');
Slicer_DiffusionTensorScalarMeasurements_cli = fullfile(SlicerBase, 'Extensions-27501/SlicerDMRI/lib/Slicer-4.10/cli-modules/DiffusionTensorScalarMeasurements');

disp(' ')
disp('=== Run DTI feature extraction ===')
DTI_parameter_E3_nrrd = fullfile(ouput_folder, 'DTI_E3.nrrd');
if ~exist(DTI_parameter_E3_nrrd, 'file')
    
    if ~exist(ouput_folder, 'dir')
        mkdir(ouput_folder)
    end
        
    compute_DTI_parameters_using_3DSlicer(nii_file, bval_file, bvec_file, ouput_folder, ...
                                          Slicer_DWIConvert_cli, Slicer_DWIToDTIEstimation_cli, Slicer_DiffusionTensorScalarMeasurements_cli);
    
    if ~exist(DTI_parameter_E3_nrrd, 'file')
        error('DTI parameter extract failed, most likely because of wrong paths of the CLI modules.')
    end
else
    disp('  * Already done!')
end

