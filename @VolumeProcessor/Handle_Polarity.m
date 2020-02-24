% File: Handle_Polarity.m 
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 28.11.2019

% Description: Handles the polarity of our bipolar US signals.

function Handle_Polarity(vp, polarityHandler)

	switch polarityHandler
		case 'abs'
			vp.volume.vol = abs(vp.volume.vol);
		case 'pos'
			vp.volume.vol(vp.volume.vol < 0) = 0;
		case 'neg'
			vp.volume.vol = -vp.volume.vol;
			vp.volume.vol(vp.volume.vol < 0) = 0;
		case 'none'
			% do nothing
		otherwise
			error('Unknwon polarity handling option')
	end

end
