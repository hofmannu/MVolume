% File: Load_From_File.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 27.11.2019

% Description: loads a volumetric dataset from the harddrive

function Load_From_File(vp, varargin)

	% default settings
	datasetPath = 'volume.mat';

	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'datasetPath'
				datasetPath = varargin{iargin+1};
			otherwise
				error('Unknown option for Load_From_File');
		end
	end

	if isfile(datasetPath)
		vp.VPrintf('Loading dataset... ', 1);
		load(datasetPath);
		vp.volume = volDataset; 
		vp.VPrintf('done!\n', 0);
	else
		error('Path is not pointing to a file');
	end


end
