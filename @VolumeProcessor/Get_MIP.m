% File: Get_MIP.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 05.12.2019

% Description: Generates a 2D projection based on different methods

function mip = Get_MIP(vp, varargin)

	method = 'simple';
	%   percentile - use outermost percentile as max declaration
	%   simple - find highest polarity value
	percentile = 0.005;
	polarity = 'both';
	cutoff = 0;
	dim = 1; % dimension to operate along

	for iargin=1:2:(nargin - 1)
		switch varargin{iargin}
			case 'method'
				method = varargin{iargin + 1};
			case 'percentile'
				percentile = varargin{iargin + 1};
			case 'polarity'
				polarity = varargin{iargin + 1};
			case 'cutoff'
				cutoff = varargin{iargin + 1};
			case 'dim'
				dim = varargin{iargin + 1};
			otherwise
				error('Unknown option passed');
		end
	end

	vol = vp.volume.vol;

	switch method
		case 'simple'
			switch polarity
				case 'pos'
					vol(vol < 0) = 0;
				case 'neg'
					vol = -vol;
					vol(vol < 0) = 0;
				case 'both'
					vol = abs(vol);		
				otherwise
					error('Invalid polarity option');
			end
			mip = squeeze(max(vol, [], dim));
		case 'percentile'
			error('Not implemented yet');
		otherwise
			error('Invalid specified method');
	end

end
