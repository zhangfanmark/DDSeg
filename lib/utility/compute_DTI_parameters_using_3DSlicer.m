function compute_DTI_parameters_using_3DSlicer(nii_file, bval_file, bvec_file, DTI_folder, Slicer_DWIConvert_cli, Slicer_DWIToDTIEstimation_cli, Slicer_DiffusionTensorScalarMeasurements_cli)

DWI_nrrd_file = fullfile(DTI_folder, 'DWI.nrrd');
DTI_nrrd_file = fullfile(DTI_folder, 'DTI.nrrd');
b0_nrrd_file  = fullfile(DTI_folder, 'b0.nrrd');
FA_nrrd_file  = fullfile(DTI_folder, 'DTI_FA.nrrd');
MD_nrrd_file  = fullfile(DTI_folder, 'DTI_MD.nrrd');
E1_nrrd_file  = fullfile(DTI_folder, 'DTI_E1.nrrd');
E2_nrrd_file  = fullfile(DTI_folder, 'DTI_E2.nrrd');
E3_nrrd_file  = fullfile(DTI_folder, 'DTI_E3.nrrd');

DWIConvert_cmd = [Slicer_DWIConvert_cli, ' --conversionMode FSLToNrrd ', ...
                 '--inputBVectors ', bvec_file, ' --inputBValues ', bval_file, ' --fslNIFTIFile ', nii_file, ' '... 
                 '--outputVolume ', DWI_nrrd_file, ' --allowLossyConversion '];

DWIToDTIEstimation_cmd = [Slicer_DWIToDTIEstimation_cli, ' --enumeration LS ', DWI_nrrd_file, ' ', DTI_nrrd_file ' ', b0_nrrd_file];

DiffusionTensorScalarMeasurements_FA_cmd = [Slicer_DiffusionTensorScalarMeasurements_cli, ' --enumeration FractionalAnisotropy ', DTI_nrrd_file, ' ', FA_nrrd_file];
DiffusionTensorScalarMeasurements_MD_cmd = [Slicer_DiffusionTensorScalarMeasurements_cli, ' --enumeration Trace ', DTI_nrrd_file, ' ', MD_nrrd_file];
DiffusionTensorScalarMeasurements_E1_cmd = [Slicer_DiffusionTensorScalarMeasurements_cli, ' --enumeration MinEigenvalue ', DTI_nrrd_file, ' ', E3_nrrd_file];
DiffusionTensorScalarMeasurements_E2_cmd = [Slicer_DiffusionTensorScalarMeasurements_cli, ' --enumeration MidEigenvalue ', DTI_nrrd_file, ' ', E2_nrrd_file];
DiffusionTensorScalarMeasurements_E3_cmd = [Slicer_DiffusionTensorScalarMeasurements_cli, ' --enumeration MaxEigenvalue ', DTI_nrrd_file, ' ', E1_nrrd_file];

sh_file = fullfile(DTI_folder, 'cmd_DTI_3DSlicer.sh');

fileID = fopen(sh_file,'w');
fprintf(fileID, [DWIConvert_cmd '\n']);
fprintf(fileID, [DWIToDTIEstimation_cmd '\n']);
fprintf(fileID, [DiffusionTensorScalarMeasurements_FA_cmd '\n']);
fprintf(fileID, [DiffusionTensorScalarMeasurements_MD_cmd '\n']);
fprintf(fileID, [DiffusionTensorScalarMeasurements_E1_cmd '\n']);
fprintf(fileID, [DiffusionTensorScalarMeasurements_E2_cmd '\n']);
fprintf(fileID, [DiffusionTensorScalarMeasurements_E3_cmd '\n']);
fclose(fileID);

system(['sh ', sh_file]);
