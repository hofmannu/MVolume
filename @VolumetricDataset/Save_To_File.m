% File: Save_To_File.m @ VolumetricDataset
% Author: Urs Hofmann
% Date: 18-Feb-2020
% Mail: hofmannu@biomed.ee.ethz.ch

function Save_To_File(vd, path)

	vol = vd.vol;
	save(path, 'vol', '-v7.3', '-nocompression');
	clear vol;

	dr = vd.dr;
	save(path, 'dr', '-append');
	clear dr;

	origin = vd.origin;
	save(path, 'origin', '-append');
	clear origin;

	name = vd.name;
	save(path, 'name', '-append');
	clear name;

end
