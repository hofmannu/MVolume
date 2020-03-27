# MVolume
A object oriented approach in MATLAB to store, process, and access volumetric datasets. Initiated to handle optoacoustic datasets but could potentially be used in other fields. Still in an experimental state and not fully tested yet. 

# Features - VolumetricDataset

Implemented:
*  Convenient definition of datasets based on resolution and origin
*  Automated dependent properties like volume size, max, min, vectors

Planned:
*  Derived classes for different imaging modalities including more specific properties

# Features - VolumeProcessor

Implemented:
*  CLAHE3D - Contrast limited adaptive histogram equilization
*  Vesselness filtering (requires k wave toolbox for now, http://k-wave.org)
*  Implementation of different deconvolution approaches
*  PolarityHandling methods for bipolar signals
*  Memory efficient resampling to differet grid sizes
*  Export function for paraview (based on vtkwrite from MATLAB fileexchange)

Planned:
*  Median and mean filtering 
*  GPU based deconvolution options
*  GPU based vesselness filtering
*  Histogram equilization over full volume instead of CLAHE3D
*  Amira export
*  `*.h5` export option
*  More memory efficient saving and loading of VolumetricDataset class
