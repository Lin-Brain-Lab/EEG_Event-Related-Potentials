%% Script to import data from Brain Products Analyzer exported files
% apply BPA history template "HistTempExport.ehtp" to desired nodes to
% produce the files to be imported

function DATA = BVimport (path, files)

% Read exported Brain Vision data into a structure
% inputs:
%   Path - a string detailing the path to the data to be imported
%   File - a list of strings detailing the files to be inported
% Outputs:
%   DATA - a structure containing the data from all files with subfields
%       partinumb - the participant number of the datasets
%       filenames - the filenames of all datasets for each participant
%       condnames - the names of all conditions for each data set 
%       data - the amplitudes for all datasets
%       channames - the names of all channels in each dataset

% add path to files to MATLAB environment
addpath (path); % adds the path to the folder containing all data

% allow user to import all files in the folder defined the input path
    %problem: 
if contains (files, 'all') % conditional loop that allows user to select all files in path folder
    allfiles = dir (path); % creates for the data in the designated folder
    allfiles = allfiles(contains({allfiles.name}, {allfiles(length(allfiles)).name(1:4)})); % redefines allfiles to only include files that contain the first four letters of the file file
    files = {allfiles.name}; % allocates the size of the files variable
end % ends the conditional loop

% create and populate the DATA structure with the information from the
% designated files
DATA = []; % creates an emplty variable named DATA
for i = 1: length (files) % creates a loop to go through each file in the designated folder
    f = files{i}; % creates a temporary variable that holds the current filename
    if i > 1 && contains ([DATA.partinumb], f(1:((strfind (f, '_')) - 1))) % if the participant already exists in the structure
        DataID = find (strcmp(f(1:((strfind (f, '_')) - 1)), {DATA.partinumb})); % creates a temporary variable to determine the dataset the file belongs to
        condID = (size (DATA(DataID).filenames, 3) + 1); % creates a temporary variable to determine the condition of the dataset
        DATA(DataID).filenames(1,1,condID) = {f}; % creats a subfield with the filename
        condname = replace (f(13:(length(f))-4), ' ', '_'); % replaces the underscore in the condition name with a space
        DATA(DataID).condnames(1,1,condID) = {condname}; % creates a subfield with the condition
        A = importdata (f, ' ', 1); % creates a temportary structure with the information from importdata
        DATA(DataID).data(:,:,condID) = A.data; % selects out the amplitude data and places it in a the 'data' subfield
        DATA(DataID).channames = A.colheaders; % selects out the channel names and places it in a the 'data' subfield
    else % if the participant does not already exist in the structure
        DataID = length (DATA) + 1; % defines temporary vairable DataID as one larger than the current number of data files
        DATA(DataID).partinumb = f(1:((strfind (f, '_')) - 1)); %  creates the first subfield containing the participant number
        DATA(DataID).filenames(1,1,1) = {f}; % creats a subfield with the filename
        condname = replace (f(13:(length(f))-4), ' ', '_'); % replaces the underscore in the condition name with a space
        DATA(DataID).condnames(1,1,1) = {condname}; % creates a subfield with the condition
        A = importdata (f, ' ', 1); % creates a temportary structure with the information from importdata
        DATA(DataID).data(:,:,1) = A.data; % selects out the amplitude data and places it in a the 'data' subfield
        DATA(DataID).channames = A.colheaders; % selects out the channel names and places it in a the 'data' subfield
    end % ends the conditional loop
end % ends the iterative loop
