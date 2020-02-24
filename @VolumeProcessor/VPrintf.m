% File: VPrintf.m @ VolumeProcessor
% Author: urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 28.11.2019

% Description: Used to redirect output into trash if we do not want to be 
% verbose.

function VPrintf(vp, message, flagName)

	if vp.flagVerbose
		if flagName
			message = ['[VolumeProcessor] ', message];
		end
		fprintf(message);
	end	

end
