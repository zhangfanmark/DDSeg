function parameter_map = load_paramemter_map(paramemter_map_file)

[~, name, ext] = fileparts(paramemter_map_file);

if length(name)>3 && strcmpi(name(end-3:end), '.nii') % for nii.gz file
    ext = '.nii';
end

if strcmpi(ext, '.nhdr') || strcmpi(ext, '.nrrd')
    parameter_map_nrrd = nhdr_nrrd_read(paramemter_map_file, true);
    parameter_map = parameter_map_nrrd.data;
    parameter_map = fliplr(parameter_map);
    parameter_map = flipud(parameter_map);
    
elseif strcmpi(ext, '.nii') || strcmpi(ext, '.gz')
    
    parameter_map_nii = load_nii(paramemter_map_file);
    parameter_map = parameter_map_nii.img;
end