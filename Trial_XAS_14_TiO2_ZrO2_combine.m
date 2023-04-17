% XAS Spectral Processing from the TIFF Image Sequence and concatenating all the data (Author: Shashi Kadam, 2023_03_22)

% Define the folder containing CSV files
folder = 'C:\Users\shashik\Documents\MATLAB\XAS Spectral Processing\scpy_TiO2_correction_11_04_2023\650C-Mix\20221105_17055_ImageOTF';

% Get a list of all CSV files in the folder
fileList = dir(fullfile(folder, '*_particle.csv'));

% Load the first CSV file to get the first column
firstFile = fullfile(folder, fileList(1).name);
data = csvread(firstFile);
firstColumn = data(:, 1)';

% Concatenate the second columns from all CSV files
for i = 1:length(fileList)
    % Load the current CSV file
    currentFile = fullfile(folder, fileList(i).name);
    data = csvread(currentFile);
    
    % Extract the second column and transpose it to a row
    secondColumn = data(:, 2)';
    
    % Concatenate the first and second columns
    if i == 1
        combinedData = [firstColumn; secondColumn];
    else
        combinedData = [combinedData; secondColumn];
    end
end

% Save the combined data to a new CSV file. RENAME THE FILE AS NAME OF THE FOLDER
combinedFile = fullfile(folder, 'particles.csv');
csvwrite(combinedFile, combinedData);



% Get a list of all CSV files in the folder
fileList = dir(fullfile(folder, '*_support.csv'));

% Load the first CSV file to get the first column
firstFile = fullfile(folder, fileList(1).name);
data = csvread(firstFile);
firstColumn = data(:, 1)';

% Concatenate the second columns from all CSV files
for i = 1:length(fileList)
    % Load the current CSV file
    currentFile = fullfile(folder, fileList(i).name);
    data = csvread(currentFile);
    
    % Extract the second column and transpose it to a row
    secondColumn = data(:, 2)';
    
    % Concatenate the first and second columns
    if i == 1
        combinedData = [firstColumn; secondColumn];
    else
        combinedData = [combinedData; secondColumn];
    end
end

% Save the combined data to a new CSV file. RENAME THE FILE AS NAME OF THE FOLDER
combinedFile = fullfile(folder, 'support.csv');
csvwrite(combinedFile, combinedData);
