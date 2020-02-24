% File: VolumetricDataset.m @ VolumetricDataset
% Author: Urs Hofmann
% Date: 24.04.2019
% Mail: hofmannu@biomed.ee.ethz.ch

% Description: Volumetric dataset, simplifies many dependent properties.

classdef VolumetricDataset < handle

  properties
    vol(:, :, :); % [z, x, y]
    dr(1, 3) single {mustBePositive, mustBeFinite} = [1, 1, 1]; % [z, x, y]
    origin(1, 3) single {mustBeFinite} = [0, 0, 0]; % [z, x, y]
  	name(1, :) char;
	end

  properties (Dependent = true)
    % dimensions of dataset
    volSize(1, 3) uint16;
    nX(1, 1) uint64;
    nY(1, 1) uint64;
    nZ(1, 1) uint64;
		nVoxel(1, 1) uint64; % overall number of voxels in our volume
    % vectors in each dimension
    vecX(1, :) single;
    vecY(1, :) single;
    vecZ(1, :) single;
    % duplicates to dr, will be handled using get and set functions 
    dX(1, 1) single;
    dY(1, 1) single;
    dZ(1, 1) single;
		% origin defines the center point of our volume
		center(1, 3) single; % center position of volume defined in [z, x, y]
		minVol(1, 1) single; % defines minimum of volume
		maxVol(1, 1) single; % defines maximum of volume
  	maxAbsVol(1, 1) single;
	end

  methods
    function volSize = get.volSize(vd)
      volSize = size(vd.vol);
    end

    % number of elements in z direction
    function nZ = get.nZ(vd)
      nZ = size(vd.vol, 1);
    end

    % number of elements in x direction
    function nX = get.nX(vd)
      nX = size(vd.vol, 2);  
    end
  
    % number of elements in y direction
    function nY = get.nY(vd)
      nY = size(vd.vol, 3);
    end

		function nVoxel = get.nVoxel(vd)
			nVoxel = vd.nX * vd.nY * vd.nZ;
		end

    % vector in x direction
    function vecX = get.vecX(vd)
      vecX = 0:(vd.nX - 1);
      vecX = single(vecX) * vd.dr(2) + vd.origin(2);
    end

    % vector in y direction
    function vecY = get.vecY(vd)
      vecY = 0:(vd.nY - 1);
			vecY = vd.origin(3) + single(vecY) * vd.dr(3);
    end

    % vector in z direction
    function vecZ = get.vecZ(vd)
      vecZ = 0:(vd.nZ - 1);
      vecZ = single(vecZ) * vd.dr(1) + vd.origin(1);
    end

    function set.dZ(vd, dZ)
      vd.dr(1) = dZ;
    end

    function dZ = get.dZ(vd)
      dZ = vd.dr(1);
    end

    function set.dX(vd, dX)
      vd.dr(2) = dX;
    end

    function dX = get.dX(vd)
      dX = vd.dr(2);
    end

    function set.dY(vd, dY)
      vd.dr(3) = dY;
    end

    function dY = get.dY(vd)
      dY = vd.dr(3);
    end

		function center = get.center(vd)
			center = vs.origin;
			center(1) = center(1) + vd.dZ * single(vd.nZ - 1) / 2;
			center(2) = center(2) + vd.dX * single(vd.nX - 1) / 2;
			center(3) = center(3) + vd.dY * single(vd.nY - 1) / 2;
		end

		function minVol = get.minVol(vd)
			minVol = min(vd.vol(:));
		end

		function maxVol = get.maxVol(vd)
			maxVol = max(vd.vol(:));
		end

		function maxAbsVol = get.maxAbsVol(vd)
			maxAbsVol = max(abs(vd.vol(:)));
		end

  end


end
