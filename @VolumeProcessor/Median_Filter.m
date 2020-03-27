% File: Median_Filter.m @ VolumeProcessor
% Author: Urs Hofmann
% Date: 15.12.2019
% Mail: hofmannu@biomed.ee.ethz.ch

% Descriotion: Runs median filter over volume for outlier removal
% 	neighbourhood - determines size of neighbourhood in z, x, y (must be odd)

function Median_Filter(vp, varargin)

	% default settings
	neighbourhood = [9, 5, 5];

	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'neighbourhood'
				neighbourhood = varargin{iargin+1};
			otherwise
				error('Unknown option passed.');
		end
	end

	vp.Handle_Polarity('abs');
	vp.VPrintf('Median filtering volume... ', 1);
	tic

	vp.volume.vol = medfilt3(vp.volume.vol, neighbourhood, 'symmetric');

	tElapsed = toc;
	txtMsg = ['done after ', num2str(tElapsed, 3), ' sec!\n'];
	vp.VPrintf(txtMsg, 0);

end
