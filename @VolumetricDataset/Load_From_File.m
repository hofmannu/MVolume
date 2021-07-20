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

			johannaFile = ~isempty(whos(mFile, 'volData')); % OR reshaped dataset
			ursFile = ~isempty(whos(mFile, 'vol'));

			if ursFile
				vol = mFile.vol;
				dim = mFile.dim;
				vd.vol = reshape(vol, dim);
				vd.dr = mFile.dr;
				vd.origin = mFile.origin;
			elseif johannaFile
				vd.vol = permute(mFile.volData, [3, 1, 2]); % saved order is x y z 
				x = mFile.x;
				y = mFile.y;
				z = mFile.z;
				dt = mFile.dt;

				dx = (x(2) - x(1)) * 1e-3; % is saved in mm
				dy = (y(2) - y(1)) * 1e-3; % is saved in mm
				vd.dr = [dt, dx, dy];
				x0 = x(1) * 1e-3;
				y0 = y(1) * 1e-3;

				% extract zero timepoint
				dz = (z(2) - z(1)) * 1e-3;
				errUs = abs(dz / 1495 * 2 - dt);
				errOa = abs(dz / 1495 - dt);

				if errUs > errOa
					% assuming OA dataset
					sosOld = dz / dt;
					t0 = z(1) * 1e-3 / sosOld;
				else
					% assuming US dataset
					sosOld = dz / dt * 2;
					t0 = z(1) * 1e-3 / sosOld * 2;
				end

				vd.origin = [t0, x0, y0];
			else
				error('Invalid formatting');
			end


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
