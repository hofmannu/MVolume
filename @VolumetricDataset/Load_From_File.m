% File: Load_From_File.m @ VolumetricDataset
% Author: Urs Hofmann
% Date: 18-Feb-2020
% Mail: hofmannu@biomed.ee.ethz.ch

function Load_From_File(vd, path)

	if isfile(path)
		load(path, 'vol');
		vd.vol = vol;
		clear vol;

		load(path, 'res');
		vd.res = res;
		clear res;

		load(path, 'origin');
		vd.origin = origin;
		clear origin;

		load(path, 'name');
		vd.name = name;
		clear name;
	else
		error('Path is not pointing to a file');
	end

end
