% File: Normalize.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 05.12.2019

% Description: Normalizes datasets towards their max / almost max

function Normalize(vp, varargin)

	% Default settings
	method = 'percentile';
	% 	percentile - we use the uppermost percentile as max declaration
	% 	simple - we use simple max / min as declaration
	percentile = 0.005; % use the uppermost 1 % of volume for max declaration
	polarity = 'both'; % use min / max / both as maximum declaration
	cutoff = 0; % used for percentile if higher values are reduced to maxVal

	for iargin=1:2:(nargin-1)
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
				error('Invalid option passed');				
		end
	end

	switch method
		case 'simple'
			switch 'polarity'
				case 'pos'
					maxVal = max(vp.volume.vol(:));
					if (maxVal <= 0)
						error('Cannot normalize, all values below 0');
					end
				case 'neg'
					maxVal = abs(min(vp.volume.vol(:)));
					if (maxVal >= 0)
						error('Cannot normalize, all values above 0');
					end
				case 'both'
					maxVal = max(abs(vp.volume.vol(:)));
					if (maxVal == 0)
						error('Cannot normalize, all values are 0');
					end
				otherwise
					error('Unknown polariy handling');
			end
		case 'percentile'
			switch polarity
				case 'pos'
					srtMatrix = sort(vp.volume.vol(:)); % works in ascending order
				case 'neg'
					srtMatrix = sort(-vp.volume.vol(:));
				case 'both'
					srtMatrix = sort(abs(vp.volume.vol(:)));
				otherwise
					error('Unknown polarity handling');
			end
			idx = round(single(vp.volume.nVoxel) * (1 - percentile));
			maxVal = srtMatrix(idx);
			if cutoff
				vp.volume.vol(vp.volume.vol > maxVal) = maxVal;
				vp.volume.vol(vp.volume.vol < -maxVal) = -maxVal;
			end
		otherwise
			error('Unknown normalization option');
	end

	vp.volume.vol = vp.volume.vol / maxVal;

end
