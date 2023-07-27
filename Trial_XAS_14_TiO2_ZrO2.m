% XA Spectral Processing from the TIFF Image Sequence (Author: Shashi Kadam, 2023_03_21)

% Define path to the TIFF images and the txt file
path_to_images = 'path_to_image_sequences(TIFF)';
path_to_txt_file = 'path_to_energy+text_files\scan 1.txt';

% Load the txt file data and extract the energy values
data = dlmread(path_to_txt_file, ';');
energy = data(:,1);

% Load the images
% (numel1 function counts the number of images. The cell function create a cell array 
% and for loop read each image and store the data in cell)
image_files = dir(fullfile(path_to_images, '*.tif'));
num_images = numel(image_files);
images = cell(num_images, 1);
for i = 1:num_images
    filename = fullfile(path_to_images, image_files(i).name);
    images{i} = imread(filename);
end

% The above images are converted into hyperspectral data. Hyperspectral
% data means collect the spectrum from each pixel.
% (A 3D matrix is created to store the hyperspectral data, 
% with the first two dimensions representing the pixels and bands, 
% and the third dimension representing the images. 
% The for loop reads in each image file, converts it to double precision, 
% reshapes it into a 2D matrix, and stores it in the 3D matrix.)
num_pixels = size(images{1}, 1) * size(images{1}, 2);
num_bands = size(images{1}, 3);
data = zeros(num_pixels, num_bands, num_images);
for i = 1:num_images
    data(:, :, i) = reshape(double(images{i}), num_pixels, num_bands);
end

% Select area of interest 1
figure;
imagesc(images{10});
h1 = drawrectangle;
mask1 = createMask(h1);
close;

% Select area of interest 2
figure;
imagesc(images{10});
h2 = drawcircle;
mask2 = createMask(h2);
close;

% Extract spectral profiles of selected areas
spectral_profiles1 = squeeze(mean(data(mask1, :, :), 1));
spectral_profiles2 = squeeze(mean(data(mask2, :, :), 1));

% Interpolate the spectral profiles to have the same length as the energy vector
interpolated_profiles1 = interp1(energy, spectral_profiles1, energy, 'linear', 'extrap');
interpolated_profiles2 = interp1(energy, spectral_profiles2, energy, 'linear', 'extrap');

% Plot the spectral profiles against energy
figure;
plot(energy, interpolated_profiles1);
hold on;
plot(energy, interpolated_profiles2);
hold off;
xlabel('Energy [eV]');
ylabel('Intensity');
title('Spectral Profiles');
legend('Particle', 'Support');


% Define base filename for csv file
base_filename = 'spectral_profile';

% Append unique identifier to filename using current date and time
current_time = datestr(now, 'yyyymmdd_HHMMSS');

% Save the interpolated spectral profiles to CSV files with unique filenames
csv_filename1 = sprintf('%s_%s_particle.csv', base_filename, current_time);
csvwrite(csv_filename1, [energy interpolated_profiles1]);

csv_filename2 = sprintf('%s_%s_support.csv', base_filename, current_time);
csvwrite(csv_filename2, [energy interpolated_profiles2]);

