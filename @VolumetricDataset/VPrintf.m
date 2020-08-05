% File: VPrintf.m @ VolumetricDataset
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 04.08.2020

% Descrption prints output information if requested

function VPrintf(vd, txtMsg, flagName)

	if vd.flagVerbose
		if flagName
			txtMsg = ['[VolumetricDataset] ', txtMsg];
		end
		fprintf(txtMsg);
	end

end