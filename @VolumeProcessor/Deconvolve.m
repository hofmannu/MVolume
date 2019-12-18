% File: Deconvolve.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 21.11.2019

% Description: Takes the volumetic image and deconvolves it with 
% the point spread function to reduce image blurring.

function Deconvolve(vp, varargin)

	tic
	% default settings
	method = 'blind';
	psf = [];
	nIter = 10;
	dampar = 0;
	polarityHandler = 'abs';
	% options
	% abs, pos, neg, none

	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'nIter'
				nIter = varargin{iargin+1};
			case 'dampar'
				dampar = varargin{iargin+1};
			case 'psf'
				psf = varargin{iargin + 1};
			case 'polarityHandler'
				polarityHandler = varargin{iargin + 1};
			case 'method'
				method = varargin{iargin + 1};
			otherwise
				error('Never heard of such an option bro');
		end
	end

	vp.Handle_Polarity(polarityHandler);
	psf = abs(psf);

	% deblur image using blind deconvolution
	% psf guess is known
	switch method
		case 'lucy'
			% deblur image based on richard lucy deconvolution
			% psf known, noise unknown
			% https://de.mathworks.com/help/images/ref/deconvlucy.html#f1-535133
			vp.volume.vol = deconvlucy(vp.volume.vol, single(psf), nIter, single(dampar));
			% ws.saftedVol - input volume for deconvolution
			% psf - estimate of point spread function
			% nIter - number of iterations
			% dampar - damping to reduce noise amplification
		case 'blind'
			[vp.volume.vol, psfr] = deconvblind(vp.volume.vol, psf, nIter);
			% psfi: initial guess of point spread function
			% 		size of matrix strongly affects the outcome
		case 'wiener'
			% deblur image based on wiener filter algorithm
			% https://de.mathworks.com/help/images/ref/deconvwnr.html
			vp.volume.vol = deconvwnr(double(vp.volume.vol), double(psf));
		otherwise
			error('Unknown deconvolution method');
	end

	vp.VPrintf('done!\n', 0);
	toc

end
