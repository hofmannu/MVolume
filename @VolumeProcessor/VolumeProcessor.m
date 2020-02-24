% File: VolumeProcessor.m @ VolumeProcessor
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 27.11.2019

% Description: Based on class volumetrix dataset, applies different filtering
% to our datasets

classdef VolumeProcessor < handle

	properties
		volume(1, 1) VolumetricDataset;
		basePath(1, :) char = []; % path
		flagVerbose(1, 1) logical = 0; % enables / disables output
	end

	methods
		Export_Paraview(vp, varargin); % generates a file readable by paraview
		Save_To_File(vp, varargin); % saves matlab array to file
		Load_From_File(vp, varargin); % loads matlab array from file
		VPrintf(vp, message, flagName);
		Frangi_Filter(vp, varargin); % vesselness enhancement running on volume
		Resampling(vp, varargin); % performs resampling of the dataset to a new defined resolution
		Adaptive_Histogram(vp, varargin); % performs adaptive histogram equilization
		s = Get_Sharpness(vp, varargin);
		Deconvolve(vp, varargin); % applies a threedimensional deconvolution
		Normalize(vp, varargin); % advanced normalization
		Get_MIP(vp, varargin);
		Power_Law_Transform(vp, varargin);
		Median_Filter(vp, varargin); % apply a median filter to the volume

		% not implemented / tested yet
		Preview(vp); % matlab based preview of volume
		
	end

end
