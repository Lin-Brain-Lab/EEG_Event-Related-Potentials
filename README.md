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
  
- BrainVision Analyzer
  <details>
  <summary> A full step-by-step break down the BV pipeline as altered to reflect HJ's critiques
  
  </summary>

  1. Using History Template -> Apply to History File(s), apply history template [HistTemp_HJEdit](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/scripts/HistTemp_HJEdit.ehtp) to all datasets
      - Applies band pass filter between 1 and 70 hz for all channels
      - Re-references all channels to the bilateral mastoids (TP9 and TP10)
      - Initiates semi-automatic ICA analysis
        - history template will pause for user input -> look at [topographical representation](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/images/eMMN-sub008_2d_ic.png) to ensure verticle oculomotor component is concentrated on component F00
         
           <details>
         
           <summary> Troubleshooting suggestions for if oculomotor component is not concentrated on component F00
         
           </summary>
         
           - If [only F01 shows significant frontal activity](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/images/eMMN-sub005_2d_ic.png) use [BV_TMMN_alt_30hcf] to apply a 30hz high cutoff filter to channels Fp1 and Fp2
           - If significant frontal activity is [spread across multiple component topographies](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/images/eMMN-sub016_2d_ic.png), or the component readout shows significant oculomotor acitivy for F01, use [BV_TMMN_alt_ICA20] to initiate a semi-automatic ICA analysis restircting the number of components calculated to 20
               - Note: this can also be done by pressing the ['recalculate' button](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/images/Recalculate.png) on the ICA options menu and changing [the components calculated to 20](https://github.com/Lin-Brain-Lab/EEG_Event-Related-Potentials/blob/main/images/Recalculate%202.png)
           - Once you are able to [isolate the oculomotor component] and remove it, apply the remaining analysis steps outlined below with [BV_TMMN_alt_seg]
         
         
           </details>

        - manually save screencap of 2D topography of independant componants
        - press 'finish' to continue history template application
      - Segments Blocks
        - segments blocks around markers 27-32 according to the boolean expression:
        ```
        FIRST (Stimulus, S 11, *, *)  OR FIRST (Stimulus, S 2, *, *) OR FIRST (Stimulus, S 12, *, *) OR FIRST (Stimulus, S 13, *, *)
        ```
        - Note: some blocks may need fine-tuning based on timing or coding irregularities. This will be indicated with an message saying 'No segments were found' the next time the history template pauses for user input.
        
           <details>
           <summary> Troubleshooting suggestions for "No segments were found." error messages
         
           </summary>
           
           - If there is a missing block indicator code at the beginning of the effected block (ie. S27), go to Transformations -> Segment Analysis Functions -> Segmentation, ensure the appropriate block is designated, change the advanced boolean code to:
             ```
             LAST (Stimulus, S 11, *, *)  OR LAST (Stimulus, S 2, *, *) OR LAST (Stimulus, S 12, *, *) OR LAST (Stimulus, S 13, *, *)
             ```
             and change the segmentation interval to -556500 - 0ms
           - If there is no missing block indicator code, or the 'no segments were found' message presists after the above change has been made, the problem is likely caused by an appended data boundary within the segmentation interval. Check the beginning and end of the block for a boundary indicator and shorten the segmentation interval so as not to include the boundary. Alternatively, shorten the segmentation interval by 500-1000ms until segmentation is possible.
         
         
           </details>
        
      - Renames markers within each block as follows:
        ```
        Old Type       	Old Description          	New Type       	New Description          	Channel  	Time Shift  	Action on Markers
        Stimulus   	    S  2                     	Stimulus   	    Deviant                  	no change	         0	  modified
        Stimulus   	    S 11                     	Stimulus   	    Standard                 	no change	         0	  modified    
        Stimulus   	    S 12                     	Stimulus   	    Standard                 	no change	         0	  modified 
        Stimulus   	    S 13                     	Stimulus   	    Standard                 	no change	         0	  modified 
        ```
      - Segments Trials
        - segments standard trials -200ms-800ms around any marker with description 'Standard' where the following boolean expression holds true
        ```
        FIRST (Stimulus, Deviant, 0, 2000)
        ```
        - segments deviant trials -200ms-800ms around any marker with description 'Deviant' where the following boolean expression holds true
        ```
        LAST (Stimulus, Standard, -2000, 0)
        ```
      - Applies a baseline correction based on the pre-stimulus time window for all segments
      - Performs an automatic artifact rejection with a 100µV threshold
      - Calculates averaged evoked response and standard deviation from trials
      - Calculates difference between deviant and standard evoked responses for each block
    
  2. 
      
  3. 
      
  </details>
