% Define folder path where images are stored
imageFolder = 'collection'; % Change this to your folder path

% Load all supported image formats
imageFormats = {'*.jpg', '*.jpeg', '*.png', '*.bmp', '*.tif', '*.tiff'};
imageFiles = [];

for k = 1:length(imageFormats)
    imageFiles = [imageFiles; dir(fullfile(imageFolder, imageFormats{k}))];
end

% Extract image names and load images dynamically
imageNames = {imageFiles.name};
numImages = numel(imageNames);

if numImages == 0
    error('No images found in the folder! Check the folder path and image formats.');
end

% Load images into a cell array
imageSet = cell(1, numImages);
for i = 1:numImages
    imageSet{i} = imread(fullfile(imageFolder, imageNames{i}));
end

disp(['Loaded ', num2str(numImages), ' images from folder: ', imageFolder]);

% Step 1: Feature-Domain Prediction Structure
mst = feature_prediction_structure(imageSet);
disp('Step 1: Feature-Domain Prediction Structure completed.');

if isempty(mst.Edges)
    warning('No MST generated. Using original images for further steps.');
    compensatedImages = imageSet;
else
    % Step 2: Spatial-Domain Disparity Compensation
    compensatedImages = spatial_disparity_compensation(imageSet, mst);
    disp('Step 2: Spatial-Domain Disparity Compensation completed.');
end

% Step 3: Frequency-Domain Redundancy Reduction
encodedData = frequency_redundancy_reduction(compensatedImages);
disp('Step 3: Frequency-Domain Redundancy Reduction completed.');

% Step 4: Lossless Recovery
reconstructedImages = lossless_recovery(encodedData);
disp('Step 4: Lossless Recovery completed.');

% Ensure reconstructed image count matches
if length(reconstructedImages) ~= numImages
    warning('⚠️ Reconstructed image count (%d) does not match original (%d). Truncating...', ...
        length(reconstructedImages), numImages);
    reconstructedImages = reconstructedImages(1:min(end, numImages));
end

% Save the reconstructed images as JPG
outputFolder = 'reconstructed_images';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

for i = 1:numImages
    imwrite(uint8(reconstructedImages{i}), fullfile(outputFolder, sprintf('reconstructed_image_%d.jpg', i)));
end

% Initialize Metrics
MSE_Values = zeros(1, numImages);
PSNR_Values = zeros(1, numImages);
bitSaving_Values = zeros(1, numImages);
SNR_Values = zeros(1, numImages);

% Compute MSE, PSNR, and SNR
for i = 1:numImages
    originalImage = double(imageSet{i});
    reconstructedImage = double(reconstructedImages{i});

    if all(size(originalImage) == size(reconstructedImage))
        MSE_Values(i) = mean((originalImage - reconstructedImage).^2, 'all');
        MAX_I = 255;
        PSNR_Values(i) = (MSE_Values(i) == 0) * Inf + (MSE_Values(i) ~= 0) * (10 * log10(MAX_I^2 / MSE_Values(i)));

        signalPower = mean(originalImage(:).^2);
        noisePower = mean((originalImage - reconstructedImage).^2, 'all');
        SNR_Values(i) = (noisePower == 0) * Inf + (noisePower ~= 0) * (10 * log10(signalPower / noisePower));
    else
        MSE_Values(i) = NaN;
        PSNR_Values(i) = NaN;
        SNR_Values(i) = NaN;
    end
end

% Compute Bit-Saving Percentage
for i = 1:numImages
    originalFileInfo = dir(fullfile(imageFolder, imageNames{i}));
    reconstructedFileInfo = dir(fullfile(outputFolder, sprintf('reconstructed_image_%d.jpg', i)));

    if ~isempty(originalFileInfo) && ~isempty(reconstructedFileInfo)
        originalSize = originalFileInfo.bytes * 8;
        compressedSize = reconstructedFileInfo.bytes * 8;
        bitSaving_Values(i) = ((originalSize - compressedSize) / originalSize) * 100;
    else
        warning('File missing or invalid: Assigning default bit-saving value for Image %d', i);
        bitSaving_Values(i) = mean(bitSaving_Values(1:max(1, i-1)), 'omitnan');
    end

    fprintf('Image %d - MSE: %.2f\n', i, MSE_Values(i));
    fprintf('Image %d - PSNR: %.2f dB\n', i, PSNR_Values(i));
    fprintf('Image %d - Bit-Saving Percentage: %.2f%%\n', i, bitSaving_Values(i));
    fprintf('Image %d - SNR: %.2f dB\n', i, SNR_Values(i));
end

% Plot Bit-Saving Percentage
figure;
bar(bitSaving_Values);
xlabel('Image Index');
ylabel('Bit-Saving Percentage (%)');
title('Bit-Saving Percentage for Each Image');
grid on;

% % Uncomment below if you want to plot MSE vs PSNR
% figure;
% plot(MSE_Values, PSNR_Values, 'bo-', 'LineWidth', 2);
% xlabel('Mean Square Error (MSE)');
% ylabel('Peak Signal-to-Noise Ratio (PSNR) in dB');
% title('MSE vs. PSNR');
% grid on;

% % Uncomment below if you want to plot MSE vs SNR
% figure;
% plot(MSE_Values, SNR_Values, 'ro-', 'LineWidth', 2);
% xlabel('Mean Square Error (MSE)');
% ylabel('Signal-to-Noise Ratio (SNR) in dB');
% title('MSE vs. SNR');
% grid on;

disp('Compression and recovery process completed.');

% Final check for lossless compression
if all(MSE_Values == 0)
    disp('Lossless compression achieved! (MSE = 0, PSNR = ∞, SNR = ∞)');
else
    disp('⚠️ Compression is not lossless.');
end












% 
% % Define folder path where images are stored
% imageFolder = 'collection'; % Change this to your folder path
% 
% % Get list of all image files in the folder
% imageFiles = dir(fullfile(imageFolder, '*.jpg')); % Change extension if needed (e.g., '*.png')
% 
% % Extract image names and load images dynamically
% imageNames = {imageFiles.name};
% numImages = numel(imageNames);
% 
% % Check if images are found
% if numImages == 0
%     error('No images found in the folder! Check the folder path and image format.');
% end
% 
% % Load images into a cell array
% imageSet = cell(1, numImages);
% for i = 1:numImages
%     imageSet{i} = imread(fullfile(imageFolder, imageNames{i}));
% end
% 
% disp(['Loaded ', num2str(numImages), ' images from folder: ', imageFolder]);
% 
% % Step 1: Feature-Domain Prediction Structure
% mst = feature_prediction_structure(imageSet);
% disp('Step 1: Feature-Domain Prediction Structure completed.');
% 
% if isempty(mst.Edges)
%     warning('No MST generated. Using original images for further steps.');
%     compensatedImages = imageSet;
% else
%     % Step 2: Spatial-Domain Disparity Compensation
%     compensatedImages = spatial_disparity_compensation(imageSet, mst);
%     disp('Step 2: Spatial-Domain Disparity Compensation completed.');
% end
% 
% % Step 3: Frequency-Domain Redundancy Reduction
%     encodedData = frequency_redundancy_reduction(compensatedImages);
% disp('Step 3: Frequency-Domain Redundancy Reduction completed.');
% 
% % Step 4: Lossless Recovery
% reconstructedImages = lossless_recovery(encodedData);
% disp('Step 4: Lossless Recovery completed.');
% 
% % ✅ Save the reconstructed images
% outputFolder = 'reconstructed_images';
% if ~exist(outputFolder, 'dir')
%     mkdir(outputFolder);
% end
% 
% for i = 1:numImages
%     imwrite(uint8(reconstructedImages{i}), fullfile(outputFolder, sprintf('reconstructed_image_%d.jpg', i)));
% end
% 
% % ✅ Initialize Metrics
% MSE_Values = zeros(1, numImages);
% PSNR_Values = zeros(1, numImages);
% bitSaving_Values = zeros(1, numImages);
% SNR_Values = zeros(1, numImages);
% 
% % ✅ Compute MSE and PSNR for Each Image
% for i = 1:numImages
%     originalImage = double(imageSet{i});
%     reconstructedImage = double(reconstructedImages{i});
% 
%     if all(size(originalImage) == size(reconstructedImage))
%         MSE_Values(i) = mean((originalImage - reconstructedImage).^2, 'all');
%         MAX_I = 255;
%         if MSE_Values(i) == 0
%             PSNR_Values(i) = Inf;
%         else
%             PSNR_Values(i) = 10 * log10(MAX_I^2 / MSE_Values(i));
%         end
%         % ✅ Compute Signal-to-Noise Ratio (SNR)
%         signalPower = mean(originalImage(:).^2); % Power of original image
%         noisePower = mean((originalImage - reconstructedImage).^2, 'all'); % Power of noise
%         if noisePower == 0
%             SNR_Values(i) = Inf; % Perfect reconstruction
%         else
%             SNR_Values(i) = 10 * log10(signalPower / noisePower);
%         end
%     else
%         MSE_Values(i) = NaN; % Mark as NaN if dimensions do not match
%         PSNR_Values(i) = NaN;
%         SNR_Values(i) = NaN;
%     end
% 
% end
% 
% 
% 
% % ✅ Compute Bit-Saving Percentage Dynamically
% for i = 1:numImages
%     originalFileInfo = dir(fullfile(imageFolder, imageNames{i}));
%     reconstructedFileInfo = dir(fullfile(outputFolder, sprintf('reconstructed_image_%d.jpg', i)));
% 
%     if ~isempty(originalFileInfo) && ~isempty(reconstructedFileInfo)
%         originalSize = originalFileInfo.bytes * 8;
%         compressedSize = reconstructedFileInfo.bytes * 8;
%         bitSaving_Values(i) = ((originalSize - compressedSize) / originalSize) * 100;
%     else
%         warning('File missing or invalid: Assigning default bit-saving value for Image %d', i);
%         bitSaving_Values(i) = mean(bitSaving_Values(1:max(1, i-1)), 'omitnan');
%     end
% 
%     fprintf('Image %d - MSE: %.2f\n', i, MSE_Values(i));
%     fprintf('Image %d - PSNR: %.2f dB\n', i, PSNR_Values(i));
%     fprintf('Image %d - Bit-Saving Percentage: %.2f%%\n', i, bitSaving_Values(i));
%     fprintf('Image %d - SNR: %.2f dB\n', i, SNR_Values(i));
% end
% 
% % ✅ Plot Results
% 
% % 🔹 Plot Bit-Saving Percentage
% figure;
% bar(bitSaving_Values);
% xlabel('Image Index');
% ylabel('Bit-Saving Percentage (%)');
% title('Bit-Saving Percentage for Each Image');
% grid on;
% 
% % % 🔹 Plot MSE vs PSNR
% % figure;
% % plot(MSE_Values, PSNR_Values, 'bo-', 'LineWidth', 2);
% % xlabel('Mean Square Error (MSE)');
% % ylab'[; el('Peak Signal-to-Noise Ratio (PSNR) in dB');
% % title('MSE vs. PSNR');
% % grid on;
% 
% % % ✅ Plot SNR vs. MSE
% % figure;
% % plot(MSE_Values, SNR_Values, 'ro-', 'LineWidth', 2);
% % xlabel('Mean Square Error (MSE)');
% % ylabel('Signal-to-Noise Ratio (SNR) in dB');
% % title('MSE vs. SNR');
% % grid on;
% 
% disp('Compression and recovery process completed.');
% % ✅ Check if compression is lossless
% if all(MSE_Values == 0)
%     disp('Lossless compression achieved! (MSE = 0, PSNR = ∞,SNR = ∞)');
% else
%     disp('Compression is not lossless.');
% end