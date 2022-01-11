% File: Filter.m @ VolumetricDataset
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 15.10.2021

% Applies filtering of the dataset along a certain dimension

function Filter(vd)

	% default values
	dimFilter = 1; % dimension along which we filter
	flagFsOverwrite = 0;

	for iargin = 1:2:(nargin-1)
		switch varargin{iargin}
			case 'dimFilter'
				if ((dimFilter > 3) || (dimFilter < 1))
					error("filter dimension must be between 1 and 3");
				end 
				dimFilter = varargin{iargin + 1};
			case 'fs'
				fs = varargin{iargin + 1};
				flagFsOverwrite = 1;
			otherwise
				error("Unknown option passed");
		end
	end

	% if no sampling frequency was manually passed
	if ~flagFsOverwrite
		fs = vd.dr(dimFilter); % get sampling frequency from dataset
	end

	permuteArray = [1, 2, 3];
	bkDim = permuteArray(1);
	permuteArray(1) = dimFilt;
	permuteArray(dimFilt) = bkDim;

	tempVol = permute(vd.vol, )

end