% File: Frangi_Filter.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 20.08.2019

% Description: Performs frangi filtering to enhance vessel structures
% in a reconstructed dataset.

function Frangi_Filter(vp, varargin)

	% default settings
	vesselRange = [5:20:80] * 1e-6; % vessel range (half of target vessel size)
	polarityHandler = 'abs';
	alpha = 0.5;
	beta = 0.5;
	gamma = 0;
	c = 1;

	for iargin=1:2:(nargin - 1)
		switch varargin{iargin}
			case 'alpha'
				alpha = varargin{iargin + 1};
			case 'beta'
				beta = varargin{iargin + 1};
			case 'gamma'
				gamma = varargin{iargin + 1};
			case 'c'
				c = varargin{iargin + 1};
			case 'vesselRange'
				vesselRange = varargin{iargin+1};
			case 'polarityHandler'
				polarityHandler = varargin{iargin+1};
			otherwise
				error("Unknown option passed to Frangi_Filter");
		end
	end
	% explanation of kwave vesselFilter function
	% 'alpha' sensitivity parameter for metric that distinguishes between plate-like and other structures (vessel-like or ball-like).
	% 'beta'	sensitivity parameter for metric that distinguishes between ball-like and other structures (vessel-like or plate-like).
	% 'c' scale sensitivity parameter for noise metric (sensitivity parameter itself is calculated automatically based on the magnitudes of the eigenvalues).
	% 'gamma' Normalisation factor for scale-space derivatives.
	% 'DisplayUpdates' boolean controlling whether command line updates are displayed.
	% 'Plot' controlling whether a maximum intensity projection of the vessel filtered image at each scale is displayed.
	% 'ColorMap' colour map to use if 'Plot' is set to true.
	vp.VPrintf('Frangi filtering data... ', 1);
	vp.Handle_Polarity(polarityHandler);
	vp.volume.vol = vesselFilter(vp.volume.vol, [vp.volume.dZ, vp.volume.dX, vp.volume.dY], vesselRange, ...
		'alpha', alpha, ...
		'beta', beta, ...
		'gamma', gamma, ...
		'c', c, ...
		'DisplayUpdates', vp.flagVerbose);
	% scale should always be half of the target vessel size

	vp.VPrintf('done!\n', 0);
	
end
