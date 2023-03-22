%% Script to create and save the MMNPlots for all datasets in a structure
%Note: BVDataMMNPlot call may need to be edited based depending on dataset
%naming conventions

function KJ_ERPLABDataPlot (DATACALC, ChanName, filedir)

% inputs
%   DATACALC - a structure created with BVDataCalc with all desired datasets
%   ChanName - a string indicating the desired channel to be plotted
%   filedir - a string indicating the folder in which the figures should be saved
% outputs
%   figures for all datasets in DATACALC
%   saved .png files for all figures



close all % cleases any open figures

PartiAll = ['IDs']; % creates a temporary variable 'PartiAll' recording all participants already plotted

% BVDataMMNPlot (DATACALC, dataID, ChanName, MMN, eERP, nERP)
for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
    PartiID = DATACALC(dataID).erpname(1:4); % creates a temporary variable named PartiID to identify the participant whose data is being plotted
    if ~contains (PartiAll, PartiID) % contitional loop determining if the participant's data has been plotted yet
        PartiAll = [PartiAll PartiID]; % updates 'PartiAll' to include current participant ID
        fig = figure('units','normalized','outerposition',[0 0 1 1]); %maximizes figure & window
        % plot Angry MMN plot
        subplot (2, 1, 1); % places the following plot on the top position of the figure
        PlotData = find (contains ({DATACALC.erpname}, [PartiID '_eeg_b27'])); % finds the indeces of data associated with block 27
        KJ_ERPLABMMNPlot (DATACALC, PlotData, ChanName, 3, 1, 2); % plots the Angry MMN Plot
        % plot Sad MMN plot
        subplot (2, 1, 2); % places the following plot on the top position of the figure
        PlotData = find (contains ({DATACALC.erpname}, [PartiID '_eeg_b29'])); % finds the indeces of data associated with block 29
        KJ_ERPLABMMNPlot (DATACALC, PlotData, ChanName, 3, 1, 2); % plots the Sad MMN Plot
        % save to folder
        file = (strcat (filedir, '\', ChanName, '_', PartiID, '_mmn', '.png')); % defines the filename of the resultant figure
        saveas (fig, file); % saves the figure
    end % end of conditional loop
end % ends the interative loop

