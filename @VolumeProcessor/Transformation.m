% File: Transformation.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 07.12.2019

% Description: Performs basic gray level transformations of the image


function GL_Transformation(vp, varargin)

	ttype = 'neg'; % transformation type

	for iargin = 1:2:(nargin - 1)
		switch varargin{iargin}
			case 'ttype'
				ttype = varargin{iargin * 1};
		otherwise
			error('Unknown option passed.');
		end
	end


	switch ttype
		case 'neg'
			vp.volume.vol = -vp.volume.vol;
		case 'log'
			minVal = vp.volume.minVal + 1;
			vp.volume.vol = factor * log(minVal + vp.volume.vol);
		
	end

end
