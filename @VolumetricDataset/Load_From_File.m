% File: Load_From_File.m @ VolumetricDataset
% Author: Urs Hofmann
% Date: 18-Feb-2020
% Mail: hofmannu@biomed.ee.ethz.ch

function Load_From_File(vd, path)

	if isfile(path)
		if strcmp(path(end-2:end), '.h5')
			vd.dr = h5read(path, '/dr');
			vd.origin = h5read(path, '/origin');
			vd.vol = h5read(path, '/vol');
		elseif strcmp(path(end-3:end), '.mat')
			mFile = matfile(path);
			vol = mFile.vol;
			dim = mFile.dim;
			vd.vol = reshape(vol, dim);
			vd.dr = mFile.dr;
			vd.origin = mFile.origin;

			% load name of dataset if present in file, otherwise ignore (not essential)
			testMe = whos(mFile, 'name');
			if ~isempty(testMe)
				vd.name = mFile.name;
			end
		else
			error('invalid file type');
		end
	else
		error('Path is not pointing to a file');
	end

end
