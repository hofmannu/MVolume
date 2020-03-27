% File: Export_Paraview.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 08.04.2019

% Description: Exports a volumetric dataset into a format readable by Paraview based
% on vtkwrite.m

% Input:
% 	- datasetPath - specifies path where we want to export to
%		- polarityHandler - specifies how we should handle the polarity
% 			none - keeps singals as bipolar signals
%				abs - uses the absolute of the signal
% 			pos - only keep positive signals
% 			neg - only keep negative signals
%		- flagNormalize
%				1 - normalizes signals to range from 0 to 1
%				0 - do not normalize anything
% 	- nonFiniteHandler - specifies how we should handle non finite values
%				none - do not remove non finite elements
% 			remove - sets non finite elements to 0
% 			error - throw an error if this occurs
% 	- xCrop,yCrop,zCrop - if passed we will crop the volume from x/y/zCrop(1) to (2)
%       specified in same units as vp.volume

function Export_Paraview(vp, varargin)

	% default settings for function
	datasetPath = 'export.vtk';
	polarityHandler = 'abs';
	nonFiniteHandler = 'remove';
	flagNormalize = 1;
	xCrop = []; % x cropping volume in mm
	yCrop = []; % y cropping volume in mm
	zCrop = []; % z cropping volume in mm

	% if no input path is specified save to default
	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'datasetPath'
				datasetPath = varargin{iargin+1};
			case 'polarityHandler'
				polarityHandler = varargin{iargin+1};
			case 'nonFiniteHandler'
				nonFiniteHandler = varargin{iargin+1};
			case 'flagNormalize'
				flagNormalize = varargin{iargin+1};
			case 'xCrop'
				xCrop = varargin{iargin + 1};
				% check that xCrop is linearly rising
				if (xCrop(1) >= xCrop(2))
					error('xCrop(2) must be bigger then xCrop(1)');
				end
				if (xCrop(1) < vp.volume.vecX(1))
					warning('Requested x crop exceeds FOV, reducing to boundary');
					xCrop(1) = vp.volume.vecX(1);
				end
				if (xCrop(2) > vp.volume.vecX(end))
					warning('Requested x crop exceeds FOV, reducing to boundary');
					xCrop(2) = vp.volume.vecX(end);
				end
			case 'yCrop'
				yCrop = varargin{iargin + 1};
				% check that yCrop is linearly rising
				if (yCrop(1) >= yCrop(2))
					error('yCrop(2) must be bigger then yCrop(1)');
				end
			
				if (yCrop(1) < vp.volume.vecY(1))
					warning('Requested y crop exceeds FOV, reducing to boundary');
					yCrop(1) = vp.volume.vecY(1);
				end
				if (yCrop(2) > vp.volume.vecY(end))
					warning('Requested y crop exceeds FOV, reducing to boundary');
					yCrop(2) = vp.volume.vecY(end);
				end
			case 'zCrop'
				zCrop = varargin{iargin + 1};
				% check that zCrop is linearly rising
				if (zCrop(1) >= zCrop(2))
					error('zCrop(2) must be bigger then zCrop(1)');
				end
			
				if (zCrop(1) < vp.volume.vecZ(1))
					warning('Requested z crop exceeds FOV, reducing to boundary');
					zCrop(1) = vp.volume.vecZ(1);
				end
				if (zCrop(2) > vp.volume.vecZ(end))
					warning('Requested z crop exceeds FOV, reducing to boundary');
					zCrop(2) = vp.volume.vecZ(end);
				end
			otherwise
				error('Unknown option passed');
		end
	end

	if (~isempty(vp.volume.vol))
		vp.VPrintf(['Exporting volume to ', datasetPath, '... '], 1);
		
		% taking care of the polarity of our signal
		vp.Handle_Polarity(polarityHandler);

		% hwo should we treat non finite elements (paraview cant handle them)
		switch nonFiniteHandler
			case 'error' % in this case we throw an error upon nonfinite elements
				if any(~isfinite(vp.volume.vol(:)))
					error('There were nonfinite elements in the volume');
				end
			case 'remove'
				nInf = sum(~isfinite(vp.volume.vol(:)));
				if nInf > 0
					pInf = nInf / vp.volume.nVoxel * 100;
					warnString = ['There were ', num2str(pInf), ' precent nonfin elements'];
					warning(warnString);
					vp.volume.vol(~isfinite(vp.volume.vol)) = 0;
				end
			case 'none'
				% do nothing about it
			otherwise
				error('Unknown option passed for our nonfinite handling');
		end

		if isempty(xCrop)
			xIdxMin = 1;
			xIdxMax = vp.volume.nX;
		else
			[~, xIdxMin] = min(abs(xCrop(1) - vp.volume.vecX));
			[~, xIdxMax] = min(abs(xCrop(2) - vp.volume.vecX));

		end
		xCropIdx = xIdxMin:xIdxMax;

		if isempty(yCrop)
			yCropMin = 1;
			yCropMax = vp.volume.nY;
		else
			[~, yCropMin] = min(abs(yCrop(1) - vp.volume.vecY));
			[~, yCropMax] = min(abs(yCrop(2) - vp.volume.vecY)); 
		end
		yCropIdx = yCropMin:yCropMax;

		if isempty(zCrop)
			zCropMin = 1; 
			zCropMax = vp.volume.nZ;
		else
			[~, zCropMin] = min(abs(zCrop(1) - vp.volune.vecZ));
			[~, zCropMax] = min(abs(zCrop(2) - vp.volume.vecZ));
		end
		zCropIdx = zCropMin:zCropMax;
		
		% if requested, normalize volume between 0 and 1
		if flagNormalize
			vp.volume.vol = vp.volume.vol - min(vp.volume.vol(zCropIdx, xCropIdx, yCropIdx), [], 'all'); % scale between 0 and 1
			vp.volume.vol = vp.volume.vol / max(vp.volume.vol(zCropIdx, xCropIdx, yCropIdx), [], 'all');
		end

		if ~isempty(vp.volume.name)
			name = vp.volume.name; 
		else
			name = 'exportedDataset';
		end


		vtkwrite(... % actual export function
			datasetPath, ... % output path for vtk file
			'structured_points', ... % dataset type (for volumes use structured_points)
			name, ... % name of dataset in paraview
			permute(vp.volume.vol(zCropIdx, xCropIdx, yCropIdx), [2, 3, 1]), ... % matlab 3d matrix
			'spacing', vp.volume.dX, vp.volume.dY, vp.volume.dZ, ... % spacing
			'origin', vp.volume.vecX(xCropIdx(1)), vp.volume.vecY(yCropIdx(1)), vp.volume.vecZ(zCropIdx(1)), ... % origin of dataset
			'BINARY');  % binary flag

		vp.VPrintf('done!\n', 0);
	else
		error('Cannot export an nonexisting volume');
	end

end
