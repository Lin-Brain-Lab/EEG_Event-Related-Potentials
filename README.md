# ERP Analysis
Codes are available here to perform event-related potential (ERP) analysis. One pipeline is based on Brain Vision Analyzer, and the other is based on EEGLAB. A passive auditory oddball paradigm was used in the data collection, and the result is referred to as emotional mismatch negativity.

## Emotional Mismatch Negativity (eMMN)
Mismatch negativity (MMN) is associated with auditory events when repetitive sounds are interrupted by an occasional oddball sound that differs in frequency or duration. It is attributed to pre-attentive auditory perception changes. MMNs evoked by emotional stimuli are called emotional MMNs, which are characterized by a stronger amplitude with a negative-going deflection.

## Analysis pipeline
- EEGLAB/ERPLAB
  1. run [scripts/ev_export.m](url)
     - import EEG data from Brain Vision Recorder eMMN-sub010.vhdr file
     - export the original event file as eMMN-sub010_ev.csv
    
  2. revise the event file based on the design in the [scripts/evlist.txt](url) and save the updated event file as eMMN-sub010_ev_r.csv
  
  3. run [scripts/ev_import_fr.m](url)
      - import the updated event file into EEG signals and save it as s010.set
      - perform a band-pass filter between 1 and 70 Hz for all channels and save it as s010_f.set
      - re-reference EEG signals to the channels at bilateral mastoids (i.e., TP9 and TP10) and save it as s010_fr.set
    
  4. run [scripts/ica.m](url)
      - perfrom an indepedent component analysis and save it as s010_fric.set
    
  5. if independent component analysis in step 4 can't produce only one significant oculomotor component, try [scripts/ica_pca.m](url) 
      - type "help runica" in the command window for parameters modification at line 37 as needed
    
  6. visually inspect the 2D topography of the independent components and save the 2D map as s010_fric.png
  
  7. remove the component with significant oculomotor activities using "Tools/Remove components" and save it as s010_fro.set
  
  8. run [scripts/eba_erp.m](url)
      - create eventlist in the ERPLAB and save it as s010_froe.set
      - epoch EEG data from 200 ms before to 800 ms after the stimulus
      - correct the post-stimulsu EEG signal based on the pre-stimulus interval and save it as s010_froeb.set
      - reject artifacts using fixed threshold of 100 µV and save it as s010_froeba.set
      - calculate evoked responses based on event codes and save it as s010_froeba.erp
      - calculate the difference between evoked responses based on the typical MMN effect and the reversed MMN effect and re-write it into s010_froeba.erp file
    
  9. Group the individual results by using "ERPLAB/Average across ERPsets (Grand Average)" and save it as Result_all.erp
  
  10. Plot ERPs using "ERPLAB/Plot ERP/Plot ERP waveforms"
  
   
- Initial Brain Products Analysis
  <details>
  <summary> A full step-by-step break down of the initial analysis pipeline done in Brain Products. This pipeline is currently being updated </summary>
    
  1. History template for [re-referencing](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/scripts/HistTempPre_rbs.ehtp)
      - Uses Transformations -> Data Preprocessing -> New Reference
      - Re-references all channels to TP9 keeping the not re-referenced TP9 in the dataset
    
  2. Marker for Bad Intervals
      - Uses Transformations -> Data Preprocessing ->  Edit Markers (graphical)
      - Manually marks all noisy and inter-block intervals as bad intervals
   
  3. History template for [further processing](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/scripts/HistTempPost_rbsAll.ehtp)
      - Applies IIR Filters
        - Uses Transformations -> Artifact Rejection/Reduction -> Data Filtering -> IIR Filters
        - Applies 1hz low cutoff filter, 40hz high cutoff filter, and 60hz notch filter
      
      - Ocular Correction
        - Uses Transformations -> Frequency and Component Analysis -> ICA
        - Applies Infomax Extended ICA algorithm to whole dataset (excluding channels TP9, TP10, FT10) 
        - user must manually identify candidate components for VEOG and HEOG from component read-out, verify candidates using topography and subtraction comparison
    
      - Block Segmentation
        - Uses Transformations -> Segment Analysis Functions -> Segmentation
        - Segments blocks from Oms-556500ms based on identifying block codes (ie S27, S28...)
        - To select only initial block designation codes, an advanced Boolean expression is used:
        ```
        FIRST (Stimulus, S 11, *, *)  OR FIRST (Stimulus, S 2, *, *) OR FIRST (Stimulus, S 12, *, *) OR FIRST (Stimulus, S 13, *, *)
        ```
        - Some blocks need fine-tuning based on timing or coding irregularities
    
      - Renaming Markers
        - Uses Transformations -> Data Preprocessing ->  Edit Markers (automatic)
        - renames all stimuli markers to either standard or deviant
        ```
        Old Type       	Old Description          	New Type       	New Description          	Channel  	Time Shift  	Action on Markers
        Stimulus   	S  2                     	Stimulus   	Deviant                  	no change	         0	modified          
        Stimulus   	S 11                     	Stimulus   	Standard                 	no change	         0	modified          
        Stimulus   	S 12                     	Stimulus   	Standard                 	no change	         0	modified          
        Stimulus   	S 13                     	Stimulus   	Standard                 	no change	         0	modified      
        ```
    
      - Trial Segmentation
        - Uses Transformations -> Segment Analysis Functions -> Segmentation
        - Segments trials from -200ms-1000ms, skipping any marked bad intervals
        - Deviant trials are defined based on the deviant stimulus codes for which the following advanced Boolean expression held true
        ```
        LAST (Stimulus, Standard, -2000, 0)
        ```
        - Standard trials are defined based on the standard stimulus codes for which the following advanced Boolean expression held true
        ```
        FIRST (Stimulus, Deviant, 0, 2000)
        ```
    
      - Baseline correction
        - Uses Transformations -> Segment Analysis Functions -> Baseline Correction
        - all segments are corrected based on the pre-stimulus interval (-200ms-0ms)
    
      - Average ERP calculation
        - Uses Transformations -> Segment Analysis Functions -> Average
        - Averages all segments in each trial are calculated along with their standard deviations
    
  4. MMN Calculation
      - Use Transformations -> Connectivity and Statistics -> Data Comparison (Difference)
      - Manually calculate the MMN based on the Deviant - Standard Average ERPs for each block
    
  5. Grand Average calculation
      - Use Transformations -> Segment Analysis Functions -> Result Evaluation -> Grand Average
      - Calculate the Grand Average of all ERP and MMN for all blocks using all datasets
    
  6. History template to [export to MATLAB](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/scripts/HistTempExport.ehtp)
      - uses Export -> Generic Data
      - Data from all averaged trials and MMNs are exported as .txt files for further data analysis, depictions, and statistics done in MATLAB
    
  7. Data results
      - Data resulting from this pipeline are depicted in a PowerPoint presentation available [here](https://docs.google.com/presentation/d/1MA_F7ikH4wJpQ0svzPNiP0EWaXcTarxt/edit?usp=share_link&ouid=107691860668063732151&rtpof=true&sd=true)

  </details>
