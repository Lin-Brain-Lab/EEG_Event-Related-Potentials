%% Script to fill out the data derived from 'BVimport' to prep it for fursther analysis/depictions

function DATACALC = BVDataCalc (DATACALC, Baseline, PeakStart, PeakEnd, AvgRadius)

% inputs:
%   DATACALC - a structure created with BVimport containing all the imported datasets to perform calculations on 
%   PeakStart - the beginning time index (post stimulus) to begin searching for the minimum peak
%   PeakEnd - the ending time index (post stimulus) to end searching for the minimum peak
%   AvgRadius - the number of values on each side of the min peak to be averaged into the peak mean
%   Baseline - the duration of the pre-stimulus interval
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

% Calculate and record min peak and mean along with associated values
for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
    for chanID = 1: length (DATACALC(dataID).channames) % for all Channels
        for condID = 1: length (DATACALC(dataID).condnames) % for all conditions
            % Populate a field with times for each data point
            DATACALC(dataID).times(:, chanID, condID) = (0-Baseline):(size(DATACALC(dataID).data, 1)) - (Baseline + 1); % defines the field .times based on the designates baseline and the size of the DATA field .data
            % Min Peak calculation
            DATACALC(dataID).minrange(:, chanID, condID) = (DATACALC(dataID).data((PeakStart + Baseline + 1):(PeakEnd + Baseline + 1), chanID, condID)); % creates the field minrange with all values searched for the minimum peak
            [M, I] = min(DATACALC(dataID).minrange(:, chanID, condID)); % creates temporary variables M and I indicating the Minimum value and its indices within the search range
            I = I + PeakStart - 1; % redefines I relative to the entire condition timeline
            % Mean Calculation around peak
            DATACALC(dataID).meanrange(:, chanID, condID) = (DATACALC(dataID).data((I + Baseline - AvgRadius + 1):(I + Baseline + AvgRadius), chanID, condID)); % creates the field meanrange with all values averaged for the PeakMean calculation
            PeakMean = mean(DATACALC(dataID).meanrange(:, chanID, condID)); % creates temporary vaiable PeakMean indicating the mean of the .meanrange values
            % Write data to structure
            DATACALC(dataID).values(:, chanID, condID) = [M, I, PeakMean, PeakStart, PeakEnd, AvgRadius]; % writes the values calculated into the .values field
            DATACALC(dataID).valuesID (:, chanID, condID) = {'M', 'I', 'PeakMean', 'PeakStart', 'PeakEnd', 'AvgRadius'}; % writes the definitions of the values in the .values field into the .valuesID field
        end % end of the iterative condition loop
    end % end of the iterative channel loop
end % end of the iterative data loop
