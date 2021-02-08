% File: Interpolate.m @ MBTransym
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 03.02.2021

% Description: Interpolates the data volume to a new vector grid

function interpData = Interpolate(vd, newVec)

	oldGrid{1} = single(vd.vecZ);
	oldGrid{2} = single(vd.vecX);
	oldGrid{3} = single(vd.vecY);

	newGrid{1} = single(newVec.z);
	newGrid{2} = single(newVec.x);
	newGrid{3} = single(newVec.y);

	F = griddedInterpolant(oldGrid, vd.vol, 'linear', 'linear');

	interpData = F(newGrid);

end