% File: Preview.m @ VolumeProcessor
% Author: Urs Hofmann
% Date: 27.03.2020
% Mail: hofmannu@biomed.ee.ethz.ch

% Description: Shows a preview of our processed datasets

function Preview(vp, varargin)

	figure('Name', 'Volumetric dataset preview', 'NumberTitle', 0);

	ax1 = subplot(2, 2, 1);

	imagesc(vp.volume.vecX, vp.volume.vecY, vp.Get_MIP('dim', 1));
	title('MIPz');
	xlabel('y [m]');
	ylabel('x [m]');
	colormap(ax1, bone(1024));
	axis image;
	colorbar;

	ax2 = subplot(2, 2, 2);
	
	imagesc(vp.volume.vecY, vp.volume.vecZ, vp.Get_MIP('dim', 2))
	title('MIPx');
	xlabel('y [m]');
	ylabel('z [m]');
	colormap(ax2, bone(1024));
	axis image;
	colorbar;

	ax3 = subplot(2, 2, 3);
	
	imagesc(vp.volume.vecX, vp.volume.vecZ, vp.Get_MIP('dim', 3));
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
