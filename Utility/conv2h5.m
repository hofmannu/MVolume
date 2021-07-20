% FIle: conv2h5.m
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 20.07.2021

% Description: Converts whatever is contained in a mat file to h5

function conv2h5(filePath)


	V = VolumetricDataset();
	V.Load_From_File(filePath);
	h5path = [filePath(1:end-3), 'h5'];
	V.Save_To_File(h5path, 'fileType', 'h5');


end