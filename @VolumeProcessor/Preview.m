% File: Preview.m @ VolumeProcessor
% Author: Urs Hofmann
% Date: 27.03.2020
% Mail: hofmannu@biomed.ee.ethz.ch

% Description: Shows a preview of our processed datasets

function Preview(vp, varargin)

	% default options
	method = 'simple'; % passed to Get_MIP function	
	polarity = 'both'; % passed through to Get_MIP function

	% process input arguments
	for iargin=1:2:(nargin -1)
		switch varargin{iargin}
			case 'method'
				method = varargin{iargin + 1};
			case 'polarity'
				polarity = varargin{iargin + 1};
			otherwise
				error('Unknown option passed');
		end
	end

	figure('Name', 'Volumetric dataset preview', 'NumberTitle', 0);

	ax1 = subplot(2, 2, 1);
	mipz = vp.Get_MIP('dim', 1, 'method', method, 'polarity', polarity);
	imagesc(vp.volume.vecY, vp.volume.vecX, mipz);
	title('MIPz');
	xlabel('y [m]');
	ylabel('x [m]');
	colormap(ax1, bone(1024));
	axis image;
	colorbar;

	ax2 = subplot(2, 2, 2);
	mipx = vp.Get_MIP('dim', 2, 'method', method, 'polarity', polarity);
	imagesc(vp.volume.vecY, vp.volume.vecZ, mipx)
	title('MIPx');
	xlabel('y [m]');
	ylabel('z [m]');
	colormap(ax2, bone(1024));
	axis image;
	colorbar;

	ax3 = subplot(2, 2, 3);
	mipy = vp.Get_MIP('dim', 3, 'method', method, 'polarity', polarity);	
	imagesc(vp.volume.vecX, vp.volume.vecZ, mipy);
	title('MIPy');
	xlabel('x [m]');
	ylabel('z [m]');
	colormap(ax3, bone(1024));
	axis image;
	colorbar;

	ax4 = subplot(2, 2, 4);
	centerY = round(vp.volume.nY / 2);
	slice = squeeze(vp.volume.vol(:, :, centerY));
	imagesc(vp.volume.vecX, vp.volume.vecZ, slice);
	maxBScanPrev = max(abs(slice(:)));
	caxis(ax4, [-maxBScanPrev, maxBScanPrev]);
	title('Center slice along x');
	xlabel('x [m]');
	ylabel('z [m]');
	colormap(ax4, redblue);
	axis image;
	colorbar;


end
