function DATA = BVimport (path, files)

% Read exported Brain Vision data into a structure
% inputs:
%   Path - a string detailing the path to the data to be imported
%   File - a list of strings detailing the files to be inported
% Outputs:
%   DATA - a structure containing the data from all files with subfields
%       partinumb
%       filenames
%       condnames
%       data
%       channames


addpath (path); % adds the path to the folder containing all data
if contains (files, 'all') % conditional loop that allows user to select all files in path folder
    allfiles = dir (path); % creates for the data in the designated folder
    files = cell([1 (length(allfiles) - 2)]); % allocates the size of the files variable
    for i = 3: length (allfiles) % for loop to select out only the relevant file names in the allfiles structure
        files(i - 2) = {allfiles(i).name}; % writes only the filenames to the files variable
    end % ends the for loop
end % ends the conditional loop

DATA = [];

for i = 1: length (files) % creates a loop to go through each file in the designated folder
    f = files{i}; % creates a temporary variable that holds the current filename
    if i > 1 && contains ([DATA.partinumb], f(1:((strfind (f, '_')) - 1))) % if the participant already had data in the structure
        DataID = find (strcmp(f(1:((strfind (f, '_')) - 1)), {DATA.partinumb})); % creates a temporary variable for the to determine the dataset the file belongs to
        condID = (size (DATA(DataID).filenames, 3) + 1);
        DATA(DataID).filenames(1,1,condID) = {f}; % creats a subfield with the filename
        condname = replace (f(13:(length(f))-4), ' ', '_');
        DATA(DataID).condnames(1,1,condID) = {condname}; % creates a subfield with the condition
        A = importdata (f, ' ', 1); % creates a temportary structure with the information from importdata
        DATA(DataID).data(:,:,condID) = A.data; % selects out the amplitude data and places it in a the 'data' subfield
        DATA(DataID).channames = A.colheaders; % selects out the channel names and places it in a the 'data' subfield
    else
        DataID = length (DATA) + 1;
        DATA(DataID).partinumb = f(1:((strfind (f, '_')) - 1)); %  creates a new structure with first subfield the participant number
        DATA(DataID).filenames(1,1,1) = {f}; % creats a subfield with the filename
        condname = replace (f(13:(length(f))-4), ' ', '_');
        DATA(DataID).condnames(1,1,1) = {condname}; % creates a subfield with the condition
        A = importdata (f, ' ', 1); % creates a temportary structure with the information from importdata
        DATA(DataID).data(:,:,1) = A.data; % selects out the amplitude data and places it in a the 'data' subfield
        DATA(DataID).channames = A.colheaders; % selects out the channel names and places it in a the 'data' subfield
    end
end %ends the for loop
