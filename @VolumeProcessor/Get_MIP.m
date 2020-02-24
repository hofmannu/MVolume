% File: Get_MIP.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 05.12.2019

% Description: Generates a 2D projection based on different methods

function mip = Get_MIP(vp, varargin)

	method = 'percentile';
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
			otherwise
				error('Unknown option passed');
		end
	end

	switch 'method'
		case 'simple'
			switch polarity
				case 'pos'
					
				otherwise
					error('Invalid polarity option');
			end
		case 'percentile'

		otherwise
			error('Invalid specified method');
	end

end
