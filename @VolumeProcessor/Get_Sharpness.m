% File: Get_Sharpness.m @ VolumetricDataset
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 02.12.2019

% Description: Calculates the Brenner sharpness over the full volume

% high sharpness values are better

function s = Get_Sharpness(vp, varargin)

	% default settings
	metric = 'brenner';
	noiseThres = 0.01;
	
	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'metric'
				metric = varargin{iargin + 1};
			case 'noiseThres'
				noiseThres = varargin{iargin+1};
			otherwise
				error('Unknown option passed.');
		end
	end

	switch metric
		case 'brenner'
			vp.Normalize('polarity', 'both');
			temp = abs(vp.volume.vol);
			temp(vp.volume.vol < noiseThres) = 0;
			bren_x = (temp(1:end-1, :, :) - temp(2:end, :, :)).^2; 
			bren_y = (temp(:, 1:end-1, :) - temp(:, 2:end, :)).^2; 
			bren_z = (temp(:, :, 1:end-1) - temp(:, :, 2:end)).^2;
			s = sum(bren_x(:)) + sum(bren_y(:)) + sum(bren_z(:));
		case 'brenner2d'
			mip = squeeze(max(abs(vp.volume.vol), [], 1));
			bren_x = (mip(1:end - 1, :) - mip(2:end, :)).^2;
			bren_y = (mip(:, 1:end - 1) - mip(:, 2:end)).^2;
			s = sum(bren_x(:)) + sum(bren_y(:));
		otherwise
			error('Unknown metric option');
	end

end
