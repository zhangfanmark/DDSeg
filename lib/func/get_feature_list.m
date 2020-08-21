function [feature_list, feature_range] = get_feature_list(parameter_type)

if strcmp(parameter_type, 'DTI')
    feature_list = {'DTI_FA', 
                    'DTI_MD', 
                    'DTI_E1', 
                    'DTI_E2', 
                    'DTI_E3'};
    
    feature_range = [0, 1;
                     -0.001, 0.004;
                     -0.001, 0.004;
                     -0.001, 0.004;
                     -0.001, 0.004;];

elseif strcmp(parameter_type, 'MKCurve')
    feature_list = {'corrected_FA',
                    'corrected_E1', 
                    'corrected_E2', 
                    'corrected_E3',
                    'corrected_MK', 
                    'corrected_AK', 
                    'corrected_RK',
                    'MKCurve_MaxMK-b0', 
                    'MKCurve_ZeroMK-b0',
                    'MKCurve_MaxMK'};
                
    feature_range = [0, 1;
                     -0.001, 0.004;
                     -0.001, 0.004;
                     -0.001, 0.004;
                     -1, 4;
                     -1, 4;
                     -1, 4;
                     [-1000, 100000];
                     [-1000, 100000];
                     -1, 4];
                
%     feature_list = {'DKI_corrected_fa', 'DKI_corrected_e1', 'DKI_corrected_e2', 'DKI_corrected_e3',...
%                     'DKI_corrected_mk', 'DKI_corrected_ak', 'DKI_corrected_rk',...
%                     'DKI_MKCurve_MaxMK_b0', 'DKI_MKCurve_ZeroMK_b0','DKI_MKCurve_MaxMK_mk'};
end