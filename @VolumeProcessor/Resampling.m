% File: Downsampling.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 28.11.2019

% Description: Resamples the volume to a new spacing

function Resampling(vp, varargin)

	vp.VPrintf('Resampling volume... ', 1);

	% default settings
	resolution = [25e-6, 25e-6, 25e-6];
	method = 'linear';

	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'resolution'
				resolution = varargin{iargin + 1};
			case 'method'
				method = varargin{iargin + 1};
			otherwise
				error('Unknown option passed to downsampling');
		end
	end

	% generate grid for interpolation
	newGrid{1} = vp.volume.vecZ(1):resolution(1):vp.volume.vecZ(end);
	newGrid{2} = vp.volume.vecX(1):resolution(2):vp.volume.vecX(end);
	newGrid{3} = vp.volume.vecY(1):resolution(3):vp.volume.vecY(end);
	gridVecs{1} = vp.volume.vecZ;
	gridVecs{2} = vp.volume.vecX;
	gridVecs{3} = vp.volume.vecY;

	F = griddedInterpolant(gridVecs, vp.volume.vol);

	vp.volume.vol = F(newGrid);

	vp.volume.dr = resolution;

	vp.VPrintf('done', 0);

end
