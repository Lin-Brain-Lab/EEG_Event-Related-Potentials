%% Script to create and save the MMNPlots for all datasets in a structure
%Note: BVDataMMNPlot call may need to be edited based depending on dataset
%naming conventions

function BVDataPlot (DATACALC, ChanName, filedir)

% inputs 
%   DATACALC - a structure created with BVDataCalc with all desired datasets
%   ChanName - a string indicating the desired channel to be plotted
%   filedir - a string indicating the folder in which the figures should be saved
% outputs
%   figures for all datasets in DATACALC
%   saved .png files for all figures



close all % cleases any open figures

% BVDataMMNPlot (DATACALC, dataID, ChanName, MMN, eERP, nERP)
for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
    fig = figure('units','normalized','outerposition',[0 0 1 1]); %maximizes figure & window
    % plot figures
    subplot (2, 1, 1); % places the following plot on the top position of the figure
    BVDataMMNPlot (DATACALC, dataID, ChanName, 1, 3, 2); % plots the Angry MMN Plot
    subplot (2, 1, 2); % places the following plot on the top position of the figure
    BVDataMMNPlot (DATACALC, dataID, ChanName, 5, 4, 6); % plots the Sad MMN Plot
    % save to folder
    file = (strcat (filedir, '\', ChanName, '_', DATACALC(dataID).partinumb, '_mmn', '.png')); % defines the filename of the resultant figure
    saveas (fig, file); % saves the figure
end % ends the interative loop

