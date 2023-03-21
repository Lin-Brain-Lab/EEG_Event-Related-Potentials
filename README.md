# TaiwanMMNData
Data analysis and results from 20 Healthy Control participants tested by Taiwan collaborators

Data preprocessed in both MATLAB's EEGLAB/ERPLAB and in BrainVision Analyzer
- Primary MATLAB preprocessing done by Moh (Uploaded to MATLAB branch)
  - Script 'EEGLABDataReMark' was written by KJ to alter the event codes in EEGLAB before segmentation

- Primary BrainVision preprocessing done by KJ (Uploaded to BrainVision branch)
  - BV history template '
  - Script 'BVimport' was written by KJ to import and sort data preprocessed in BrainVision into a structure in MATLAB
  - Script 'BVDataCalc' was written by KJ to calculate the MMN minimum peak and its average for further analysis
  - Script 'BVDataMMNPlot' was written by KJ to create plots depicting the MMN minimun peak and its average
  - Script 'BVDataPlot' was written by KJ to call create and save a 'BVDataMMNPlot' for each dataset in a 'BVDataCalc' derived structure
  - Image 'Fz_eMMN-sub015_mmn.png' is a sample of the output of script 'BVDataMMNPlot'
