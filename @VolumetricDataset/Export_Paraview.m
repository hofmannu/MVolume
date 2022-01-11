% File: Export_Paraview.m @ VolumetricDataset
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 21.10.2021

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

function Export_Paraview(vd, varargin)

	% default settings for function
	filePath = 'export.vtk';
	polarityHandler = 'abs';
	nonFiniteHandler = 'remove';
	flagNormalize = 1;
	xCrop = []; % x cropping volume in mm
	yCrop = []; % y cropping volume in mm
	zCrop = []; % z cropping volume in mm

	% if no input path is specified save to default
	for iargin=1:2:(nargin-1)
		switch varargin{iargin}
			case 'filePath'
				filePath = varargin{iargin+1};
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
				if (xCrop(1) < vd.vecX(1))
					warning('Requested x crop exceeds FOV, reducing to boundary');
					xCrop(1) = vd.vecX(1);
				end
				if (xCrop(2) > vp.volume.vecX(end))
					warning('Requested x crop exceeds FOV, reducing to boundary');
					xCrop(2) = vd.vecX(end);
				end
			case 'yCrop'
				yCrop = varargin{iargin + 1};
				% check that yCrop is linearly rising
				if (yCrop(1) >= yCrop(2))
					error('yCrop(2) must be bigger then yCrop(1)');
				end
			
				if (yCrop(1) < vd.vecY(1))
					warning('Requested y crop exceeds FOV, reducing to boundary');
					yCrop(1) = vd.vecY(1);
				end
				if (yCrop(2) > vd.vecY(end))
					warning('Requested y crop exceeds FOV, reducing to boundary');
					yCrop(2) = vd.vecY(end);
				end
			case 'zCrop'
				zCrop = varargin{iargin + 1};
				% check that zCrop is linearly rising
				if (zCrop(1) >= zCrop(2))
					error('zCrop(2) must be bigger then zCrop(1)');
				end
			
				if (zCrop(1) < vd.vecZ(1))
					warning('Requested z crop exceeds FOV, reducing to boundary');
					zCrop(1) = vd.vecZ(1);
				end
				if (zCrop(2) > vd.vecZ(end))
					warning('Requested z crop exceeds FOV, reducing to boundary');
					zCrop(2) = vd.vecZ(end);
				end
			otherwise
				error('Unknown option passed');
		end
	end

	if (~isempty(vd.vol))
		vd.VPrintf(['Exporting volume to ', filePath, '... '], 1);
		
		% taking care of the polarity of our signal
		vd.Handle_Polarity(polarityHandler);

		% hwo should we treat non finite elements (paraview cant handle them)
		switch nonFiniteHandler
			case 'error' % in this case we throw an error upon nonfinite elements
				if any(~isfinite(vd.vol(:)))
					error('There were nonfinite elements in the volume');
				end
			case 'remove'
				nInf = sum(~isfinite(vd.vol(:)));
				if nInf > 0
					pInf = nInf / vd.nVoxel * 100;
					warnString = ['There were ', num2str(pInf), ' precent nonfin elements'];
					warning(warnString);
					vd.vol(~isfinite(vd.vol)) = 0;
				end
			case 'none'
				% do nothing about it
			otherwise
				error('Unknown option passed for our nonfinite handling');
		end

		if isempty(xCrop)
			xIdxMin = 1;
			xIdxMax = vd.nX;
		else
			[~, xIdxMin] = min(abs(xCrop(1) - vd.vecX));
			[~, xIdxMax] = min(abs(xCrop(2) - vd.vecX));

		end
		xCropIdx = xIdxMin:xIdxMax;

		if isempty(yCrop)
			yCropMin = 1;
			yCropMax = vd.nY;
		else
			[~, yCropMin] = min(abs(yCrop(1) - vd.vecY));
			[~, yCropMax] = min(abs(yCrop(2) - vd.vecY)); 
		end
		yCropIdx = yCropMin:yCropMax;

		if isempty(zCrop)
			zCropMin = 1; 
			zCropMax = vd.nZ;
		else
			[~, zCropMin] = min(abs(zCrop(1) - vd.vecZ));
			[~, zCropMax] = min(abs(zCrop(2) - vd.vecZ));
		end
		zCropIdx = zCropMin:zCropMax;
		
		% if requested, normalize volume between 0 and 1
		if flagNormalize
			vd.vol = vd.vol - min(vd.vol(zCropIdx, xCropIdx, yCropIdx), [], 'all'); % scale between 0 and 1
			vd.vol = vd.vol / max(vd.vol(zCropIdx, xCropIdx, yCropIdx), [], 'all');
		end

		if ~isempty(vd.name)
			name = vd.name; 
		else
			name = 'exportedDataset';
		end


		vtkwrite(... % actual export function
			filePath, ... % output path for vtk file
			'structured_points', ... % dataset type (for volumes use structured_points)
			name, ... % name of dataset in paraview
			permute(vd.vol(zCropIdx, xCropIdx, yCropIdx), [2, 3, 1]), ... % matlab 3d matrix
			'spacing', vd.dX, vd.dY, vd.dZ, ... % spacing
			'origin', vd.vecX(xCropIdx(1)), vd.vecY(yCropIdx(1)), vd.vecZ(zCropIdx(1)), ... % origin of dataset
			'BINARY');  % binary flag

		vd.VPrintf('done!\n', 0);
	else
		error('Cannot export an nonexisting volume');
	end


end