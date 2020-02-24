% File: Power_Law_Transform.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 12.12.2019

% Description: Performs a power law transformation of the volume.

function Power_Law_Transform(vp, varargin)

	% default values:
	gamma = 0.3;
	flagNormalize = 1;

	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'gamma'
				gamma = varargin{iargin + 1};
			case 'flagNormalize'
				flagNormalize = varargin{iargin + 1};
			otherwise
				error('Unknown option passed');
		end
	end

	minOld = vp.volume.minVol;
	maxOld = vp.volume.maxVol;

	vp.volume.vol = vp.volume.vol^gamma;

	% restore previous range
	if flagNormalize
		vp.volume.vol = vp.volume.vol - vp.volume.minVol;
		vp.volume.vol = vp.volume.vol / vp.volume.maxVol;
		vp.volume.vol = vp.volume.vol * (maxOld - minOld);
		vp.volume.vol = vp.volume.vol + minOld;
	end

end
