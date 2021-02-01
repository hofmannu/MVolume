% File: Load_From_File.m @ VolumetricDataset
% Author: Urs Hofmann
% Date: 18-Feb-2020
% Mail: hofmannu@biomed.ee.ethz.ch

function Load_From_File(vd, path)

	if isfile(path)

		mFile = matfile(path);
		vd.vol = mFile.vol;
		vd.dr = mFile.dr;
		vd.origin = mFile.origin;

		% load name of dataset if present in file, otherwise ignore (not essential)
		testMe = whos(mFile, 'name');
		if ~isempty(testMe)
			vd.name = mFile.name;
		end

	else
		error('Path is not pointing to a file');
	end

end
