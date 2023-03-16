%% Script to fill out the data derived from 'BVimport' to prep it for fursther analysis/depictions
function DATACALC = BVDataCalc (DATACALC, Baseline, PeakStart, PeakEnd, AvgRadius)
% inputs:
%   DATA
%   PeakStart
%   PeakEnd
%   AvgRadius
%   Baseline
%Output
%   DATACALC with fieldnames:
%       partinumb
%       filenames
%       condnames
%       data
%       channames
%       times
%       minrange
%       meanrange
%       values
%       valuesID

%% Peak Calculation

for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
    for chanID = 1: length (DATACALC(dataID).channames) % for all Channels
        for condID = 1: length (DATACALC(dataID).condnames) % for all conditions
            % Populate a field with times for each data point
            DATACALC(dataID).times(:, chanID, condID) = (0-Baseline):(size(DATACALC(dataID).data, 1)) - (Baseline + 1);
            % Min Peak calculation
            DATACALC(dataID).minrange(:, chanID, condID) = (DATACALC(dataID).data((PeakStart + Baseline):(PeakEnd + Baseline), chanID, condID));
            [M, I] = min(DATACALC(dataID).minrange(:, chanID, condID));
            I = I + PeakStart;
            % Mean Calculation around peak
            DATACALC(dataID).meanrange(:, chanID, condID) = (DATACALC(dataID).data((I + Baseline - AvgRadius):(I + Baseline + AvgRadius), chanID, condID));
            PeakMean = mean(DATACALC(dataID).meanrange(:, chanID, condID));
            % Write data to structure
            DATACALC(dataID).values(:, chanID, condID) = [M, I, PeakMean, PeakStart, PeakEnd, AvgRadius];
            DATACALC(dataID).valuesID (:, chanID, condID) = {'M', 'I', 'mean', 'PeakStart', 'PeakEnd', 'AvgRadius'};
        end
    end
end






