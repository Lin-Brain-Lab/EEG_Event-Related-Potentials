%% Script to calculate the MMN minimum peak from from the Taiwan Dataset's ERPLAB produced MMN ERPs

function DATACALC = KJ_ERPLABDataCalc (ALLERP, PeakStart, PeakEnd, AvgRadius)


% inputs:
%   DATACALC - a structure created with BVimport containing all the imported datasets to perform calculations on 
%   PeakStart - the beginning time index (post stimulus) to begin searching for the minimum peak
%   PeakEnd - the ending time index (post stimulus) to end searching for the minimum peak
%   AvgRadius - the number of values on each side of the min peak to be averaged into the peak mean
% Output
%   DATACALC with fieldnames:
%       partinumb - the participant number of the datasets
%       filenames - the filenames of all datasets for each participant
%       condnames - the names of all conditions for each data set 
%       data - the amplitudes for all datasets
%       channames - the names of all channels in each dataset
%       times - the latency of each amplitude in .data
%       minrange - the values used to determine the minimum peak
%       meanrange - the values used to determine the peak mean
%       values - the result of all calculations in this function
%       valuesID - the identity of each value in .values

DATACALC = ALLERP; % creates a structure 'DATACALC' equal to ERPLAB generated ALLERP so as not to alter the originating information in ALLERP when performing transformations
PeakStart = find (ismember(ALLERP(1).times, PeakStart));
PeakEnd = find (ismember(ALLERP(1).times, PeakEnd));

for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
    for chanID = 1: length (DATACALC(dataID).chanlocs) % for all Channels
        for condID = 1: length (DATACALC(dataID).bindescr) % for all conditions
            % Min Peak calculation
            DATACALC(dataID).minrange(chanID, :, condID) = DATACALC(dataID).bindata(chanID, PeakStart:PeakEnd, condID); % creates the field minrange with all values searched for the minimum peak
            [M, I] = min(DATACALC(dataID).minrange(chanID, :, condID)); % creates temporary variables M and I indicating the Minimum value and its indices within the search range
            I = I + PeakStart - 1; % redefines I relative to the entire condition timeline
            % Mean Calculation around peak
            DATACALC(dataID).meanrange(chanID, :, condID) = (DATACALC(dataID).bindata(chanID, (I - AvgRadius + 1):(I + AvgRadius), condID)); % creates the field meanrange with all values averaged for the PeakMean calculation
            PeakMean = mean(DATACALC(dataID).meanrange(chanID, :, condID)); % creates temporary vaiable PeakMean indicating the mean of the .meanrange values
            % Write data to structure
            DATACALC(dataID).values(chanID, :, condID) = [M, DATACALC(1).times(I), PeakMean, DATACALC(1).times(PeakStart), DATACALC(1).times(PeakEnd), AvgRadius]; % writes the values calculated into the .values field
            DATACALC(dataID).valuesID (chanID, :, condID) = {'M', 'I', 'PeakMean', 'PeakStart', 'PeakEnd', 'AvgRadius'}; % writes the definitions of the values in the .values field into the .valuesID field
        end % end of the iterative condition loop
    end % end of the iterative channel loop
end % end of the iterative data loop