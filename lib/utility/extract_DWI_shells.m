function extract_DWI_shells(in_data_nii, in_bval_file, in_bvec_file, removed_bvals, out_data_nii, out_bval_file, out_bvec_file)

if ~exist(out_data_nii, 'file')
    bval = load(in_bval_file);
    bvec = load(in_bvec_file);
    nii_data = load_untouch_nii(in_data_nii);

    removed_shells = [];
    for b = removed_bvals
        removed_shells = [removed_shells find(bval == b)];
    end

    disp(['- A total of ', num2str(length(removed_shells)), ' images will be removed.']);

    nii_data.img(:,:,:,removed_shells) = [];
    nii_data.hdr.dime.dim(5) = size(nii_data.img,4);

    bval(removed_shells) = [];
    bvec(:, removed_shells) = [];

    bval = bval';

    disp([' - A total of ', num2str(length(bval)), ' images are retained.']);

    save(out_bval_file, 'bval', '-ascii');
    save(out_bvec_file, 'bvec', '-ascii');
    save_untouch_nii(nii_data, out_data_nii);
else
    disp(' - Shell extraced')
end