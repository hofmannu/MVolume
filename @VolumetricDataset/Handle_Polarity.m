% File: Handle_Polairty.m @ VolumetricDataset
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 21.10.2021

function Handle_Polairty(vd, polarityHandler)

	switch polarityHandler
		case 'abs'
			vd.vol = abs(vd.vol);
		case 'pos'
			vd.vol(vd.vol < 0) = 0;
		case 'neg'
			vd.vol = -vd.vol;
			vd.vol(vd.vol < 0) = 0;
		case 'none'
			% do nothing
		otherwise
			error('Unknwon polarity handling option')
	end

end