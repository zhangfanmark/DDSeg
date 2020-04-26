function Unet_folder = get_CNN_model(parameter_type)

if strcmp(parameter_type, 'DTI')
    Unet_folder = fullfile('CNN-models', 'Unet-DTI-n5-ATloss-GMWMCSF');
elseif strcmp(parameter_type, 'MKCurve')
    Unet_folder = fullfile('CNN-models', 'Unet-MKCurve-n10-ATloss-GMWMCSF');
end