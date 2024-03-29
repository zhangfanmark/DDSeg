function err = save_nifti(hdr,niftifile)
% err = save_nifti(hdr,niftifile)
%
% Only uncompressed (so far)
% pixel data should be in hdr.vol

err = 1;
if(nargin ~= 2)
  fprintf('err = save_nifti(hdr,niftifile)\n');
  return;
end

ext = niftifile((strlen(niftifile)-2):strlen(niftifile));
if(strcmpi(ext,'.gz'))
  gzip_needed = 1;
  niftifile = niftifile(1:strlen(niftifile)-3);
  %fprintf('First, saving to %s before compressing\n',niftifile);
else
  gzip_needed = 0;
end


fp = fopen(niftifile,'w');
if(fp == -1)
  fprintf('ERROR: could not open %s\n',niftifile);
  return;
end

hdr.data_type = [hdr.data_type(:)' repmat(0,[1 10])];
hdr.data_type = hdr.data_type(1:10);

hdr.db_name = [hdr.data_type(:)' repmat(0,[1 18])];
hdr.db_name = hdr.db_name(1:18);

hdr.dim = ones(1,8);
hdr.dim(1) = numel(size(hdr.vol));
hdr.dim(2) = size(hdr.vol,1);
hdr.dim(3) = size(hdr.vol,2);
hdr.dim(4) = size(hdr.vol,3);
hdr.dim(5) = size(hdr.vol,4);

hdr.pixdim = [hdr.pixdim(:)' repmat(0,[1 8])];
hdr.pixdim = hdr.pixdim(1:8);

hdr.descrip = [hdr.descrip(:)' repmat(0,[1 80])];
hdr.descrip = hdr.descrip(1:80);

hdr.aux_file = [hdr.aux_file(:)' repmat(0,[1 24])];
hdr.aux_file = hdr.aux_file(1:24);

hdr.intent_name = [hdr.intent_name(:)' repmat(0,[1 16])];
hdr.intent_name = hdr.intent_name(1:16);

hdr.magic = [hdr.magic(:)' repmat(0,[1 4])];
hdr.magic = hdr.magic(1:4);

if(isempty(hdr.regular))  hdr.regular  = 0; end
if(isempty(hdr.dim_info)) hdr.dim_info = 0; end
if(isempty(hdr.slice_code)) hdr.slice_code = 0; end
if(isempty(hdr.xyzt_units)) hdr.xyzt_units = 0; end % should be err

hdr.vox_offset = 352; % not 348
fwrite(fp,348,'int');
fwrite(fp,hdr.data_type,    'char');
fwrite(fp,hdr.db_name,      'char');
fwrite(fp,hdr.extents,      'int');
fwrite(fp,hdr.session_error,'short');
fwrite(fp,hdr.regular,      'char');
fwrite(fp,hdr.dim_info,     'char');
fwrite(fp,hdr.dim,          'short');
fwrite(fp,hdr.intent_p1,    'float');
fwrite(fp,hdr.intent_p2,    'float');
fwrite(fp,hdr.intent_p3,    'float');
fwrite(fp,hdr.intent_code,  'short');
fwrite(fp,hdr.datatype,     'short');
fwrite(fp,hdr.bitpix,       'short');
fwrite(fp,hdr.slice_start,  'short');
fwrite(fp,hdr.pixdim,       'float');
fwrite(fp,hdr.vox_offset,   'float');
fwrite(fp,hdr.scl_slope,    'float');
fwrite(fp,hdr.scl_inter,    'float');
fwrite(fp,hdr.slice_end,    'short');
fwrite(fp,hdr.slice_code,   'char');
fwrite(fp,hdr.xyzt_units,   'char');
fwrite(fp,hdr.cal_max,      'float');
fwrite(fp,hdr.cal_min,      'float');
fwrite(fp,hdr.slice_duration,'float');
fwrite(fp,hdr.toffset,       'float');
fwrite(fp,hdr.glmax,         'int');
fwrite(fp,hdr.glmin,         'int');
fwrite(fp,hdr.descrip,       'char');
fwrite(fp,hdr.aux_file,      'char');
fwrite(fp,hdr.qform_code,    'short');
fwrite(fp,hdr.sform_code,    'short');
fwrite(fp,hdr.quatern_b,     'float');
fwrite(fp,hdr.quatern_c,     'float');
fwrite(fp,hdr.quatern_d,     'float');
fwrite(fp,hdr.quatern_x,     'float');
fwrite(fp,hdr.quatern_y,     'float');
fwrite(fp,hdr.quatern_z,     'float');
fwrite(fp,hdr.srow_x,        'float');
fwrite(fp,hdr.srow_y,        'float');
fwrite(fp,hdr.srow_z,        'float');
fwrite(fp,hdr.intent_name,   'char');
fwrite(fp,hdr.magic,         'char');

% Pad to get to 352 bytes (header size is 348)
fwrite(fp,0,'char');
fwrite(fp,0,'char');
fwrite(fp,0,'char');
fwrite(fp,0,'char');

npix = prod(size(hdr.vol));
switch(hdr.datatype)
 case   2, nitemswritten = fwrite(fp,hdr.vol,'char');
 case   4, nitemswritten = fwrite(fp,hdr.vol,'short');
 case   8, nitemswritten = fwrite(fp,hdr.vol,'int');
 case  16, nitemswritten = fwrite(fp,hdr.vol,'float');
 case  64, nitemswritten = fwrite(fp,hdr.vol,'double');
 case 512, nitemswritten = fwrite(fp,hdr.vol,'ushort');
 case 768, nitemswritten = fwrite(fp,hdr.vol,'uint');
 otherwise,
  fprintf('WARNING: data type %d not supported, but writing as float',...
	  hdr.datatype);
  nitemswritten = fwrite(fp,hdr.vol,'float');
  return;
end
fclose(fp);

if(npix ~= nitemswritten)
  fprintf('ERROR: tried to write %d, but only wrote %d',npix,nitemswritten);
  return;
end

if(gzip_needed)
  cmd = sprintf('gzip -f %s', niftifile);
  %fprintf('Compressing with\n');
  %fprintf('   %s\n',cmd);
  unix(cmd);
end


err = 0;
return;


