% File: Save_To_File.m @ VolumetricDataset
% Author: Urs Hofmann
% Date: 18-Feb-2020
% Mail: hofmannu@biomed.ee.ethz.ch

% Description: saves dataset to file

function Save_To_File(vd, filePath, varargin)

	vd.VPrintf('Saving data to file... ', 1);

	% default arguments
	flagOverwrite = 1; % should we overwrite if file exists
	fileType = 'mat'; % export file type

	% read in user specific arguments
	for iargin=1:2:(nargin - 2)
		switch varargin{iargin}
			case 'fileType'
				fileType = varargin{iargin + 1};
			case 'flagOverwrite'
				flagOverwrite = varargin{iargin + 1};
			otherwise
				error('Invalid argument passed to function');
		end
	end

	if ~flagOverwrite && isfile(filePath)
		warning("File already exists, not gonna overwrite");
	else
		switch fileType
			case 'mat'
				vol = vd.vol(:)';
				save(filePath, 'vol', '-v7.3', '-nocompression');
				clear vol;

				dr = vd.dr;
				save(filePath, 'dr', '-append');
				clear dr;

				origin = vd.origin;
				save(filePath, 'origin', '-append');
				clear origin;

				name = vd.name;
				save(filePath, 'name', '-append');
				clear name;

				dim = uint64(size(vd.vol));
				save(filePath, 'dim', '-append');
				clear dim;
			case 'h5'
				% in case file already exists we should delete it first
				if isfile(filePath)
					delete(filePath);
				end 
				
				% save volume
				h5create(filePath, '/vol', size(vd.vol), 'Datatype', 'single');
				h5write(filePath, '/vol', single(vd.vol));

				% save resolution
				h5create(filePath, '/dr', 3, 'Datatype', 'single');
				h5write(filePath, '/dr', single(vd.dr));

				% save origin
				h5create(filePath, '/origin', 3, 'Datatype', 'single');
				h5write(filePath, '/origin', single(vd.origin));

				% save dimensions of volume
				h5create(filePath, '/dim', 3, 'Datatype', 'uint32');
				h5write(filePath, '/dim', uint32(size(vd.vol)));

			case 'vtk'

			otherwise
				error('Export type not implemented');
		end
	end

	vd.VPrintf('done!\n', 0);
end
