function BVStats (DATACALC, ChanNames, filedir)

close all % cleases any open figures

for Chan = 1 : length (ChanNames) % iterative loop for all channels designated
    chanID = find(ismember(DATACALC(1).channames,ChanNames(Chan))); % defines the temporary variable chanID based on the input ChanName
    % create a matrix with the relevant data
    for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
        for condID = 1: length (DATACALC(dataID).condnames) % for all conditions
            ScatterXData (dataID, condID) = DATACALC(dataID).values(2, chanID, condID); % creates a matrix for the scatter plot X values
            ScatterYData (dataID, condID) = DATACALC(dataID).values(3, chanID, condID); % creates a matrix for the scatter plot y values
        end % ends the iterative loop for all conditions
    end % ends the iterative loop for all datasets
    
    % calculate paired sample t-test
    [h,p] = ttest(ScatterYData(:,1),ScatterYData(:,5)); % applies a paired-samples t-test to the Angry and Sad MMN data
    
    % create scatterplot of values
    XData (1:20,1) = 1; % creates a temporary variable XData with values for the Angry MMN amplitudes
    XData (1:20,2) = 2; % updates the variable XData with values for the Sad MMN amplitudes
    fig = figure('units','normalized','outerposition',[0 0 1 1]); %maximizes figure & window
    scatter (XData(:, 1), ScatterYData(:, 1), 20, 'r', 'filled', 'DisplayName', 'Angry'); % plots the Angry amplitude points
    hold on % ensures all following plot occur on the same figure
    scatter (XData(:, 2), ScatterYData(:, 5), 20, 'b', 'filled', 'DisplayName', 'Sad'); % plots the Sad amplitude points
    for dataID = 1: length (ScatterYData) % for all rows in the ScatterYData variable
        plot ([1 2],[ScatterYData(dataID, 1) ScatterYData(dataID, 5)], 'color', [0.3 0.3 0.3]); % plot lines between a participants Angry and Sad data
    end % ends the iterative row loop
    hold off % removes figure hold
    
    % customize scatterplot
    title ([ChanNames(Chan) ' Average Means, p=' {p}]); % creates a title for the figure
    legend ('Angry', 'Sad') % creates a legend for the figure
    ylabel ('Average Amplitude') %sets the y-axis label
    xlabel ('Latency (ms poststimulus)') %sets the x-axis label
    xlim ([0 3]); % extends the x limits in both directions
    ax = gca; %sets the structure of properties of the graph into 'ax'
    ax.YDir = 'reverse'; % reverses the direction of the y-axis
    
    
    % save to folder
    file = (strcat (filedir, '\', ChanNames{Chan}, '_paired t-test', '.png')); % defines the filename of the resultant figure
    saveas (fig, file); % saves the figure
end % ends the iterative channel loop