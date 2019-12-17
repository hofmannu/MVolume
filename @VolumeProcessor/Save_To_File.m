% File: Save_To_File.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 28.11.2019

% Description: saves the volume to a mat file which can be loaded at any 
% timepoint

function Save_To_File(vp, varargin)

	% default option:
	datasetPath = 'volume.mat';

	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'datasetPath'
				datasetPath = varargin{iargin+1};
			otherwise
				error('invalid option passed');
		end
	end

	volDataset = vp.volume;
	message = ['Saving dataset to', datasetPath, '... '];
	vp.VPrintf(message, 1);
	save(datasetPath, 'volDataset', '-v7.3', '-nocompression');
	vp.VPrintf('done!\n', 0);

end
