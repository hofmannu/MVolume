% File: Interpolate.m @ MBTransym
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 03.02.2021

% Description: Interpolates the data volume to a new vector grid

function interpData = Interpolate(vd, newVec)

	vd.VPrintf('Interpolating dataset... ', 1);

	% throw warning if we crash into any boundaries
	if newVec.z(1) < vd.vecZ(1)
		warning('crashing into lower boundary along z');
	end

	if newVec.z(end) > vd.vecZ(end)
		fprintf('requested z end: %f, present z end: %f\n', ...
			newVec.z(end), vd.vecZ(end))
		warning('crashing into upper boundary along z');

	end

	if newVec.x(1) < vd.vecX(1)
		warning('crashing into lower boundary along x');
	end

	if newVec.x(end) > vd.vecX(end)
		warning('crashing into upper boundary along x');
	end

	if newVec.y(1) < vd.vecY(1)
		warning('crashing into lower boundary along y');
	end

	if newVec.y(end) > vd.vecY(end)
		warning('crashing into upper boundary along y');
	end

	oldGrid{1} = single(vd.vecZ);
	oldGrid{2} = single(vd.vecX);
	oldGrid{3} = single(vd.vecY);

	newGrid{1} = single(newVec.z);
	newGrid{2} = single(newVec.x);
	newGrid{3} = single(newVec.y);

	F = griddedInterpolant(oldGrid, vd.vol, 'linear', 'linear');

	interpData = F(newGrid);

	vd.VPrintf('done!\n', 0);

end