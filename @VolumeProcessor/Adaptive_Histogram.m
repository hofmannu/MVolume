% File: Adaptive_Histogram.m @ WSAFT
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 23.11.2019

% Description: Performs an adaptive histogram equilization in 3D

% Important settings:
% 	- clipLimit 		Defines noise threshold for histogram
% 	- subVolSizeMm	Size of the used bins in m
%		- binSize				Number of bins for histogram 

function Adaptive_Histogram(vp, varargin)

	binSize = 500;
	subVolSize = [0.5, 1, 1] * 1e-3; % [z, x, y]
	clipLimit = 0.02;
	polarityHandler = 'abs';

	for iargin=1:2:(nargin - 1)
		switch varargin{iargin}
			case 'binSize'
				binSize = varargin{iargin + 1};
			case 'subVolSize'
				subVolSize = varargin{iargin + 1};
			case 'clipLimit'
				clipLimit = varargin{iargin + 1};
			case 'polarityHandler'
				polarityHandler = varargin{iargin + 1};
			otherwise
				error('Unknown option');
		end
	end

	vp.VPrintf('Starting CLAHE3D... ', 1);
	vp.Handle_Polarity(polarityHandler);
	
	subVolSize = uint64(subVolSize ./ vp.volume.dr);
	clipLimit = single(clipLimit * vp.volume.maxVol);
	binSize = uint64(binSize);
	clahe3dmex(vp.volume.vol, subVolSize, clipLimit, binSize);

	vp.VPrintf('done!\n', 0);

end
