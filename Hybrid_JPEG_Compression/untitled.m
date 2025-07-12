% 
% imageSet = {imread('image1.jpg'), imread('image2.jpg'), imread('image3.jpg'),imread('image4.jpg'),imread('image9.jpg')};
% 
% % Step 1: Feature-Domain Prediction Structure
% mst = feature_prediction_structure(imageSet);
% disp('Step 1: Feature-Domain Prediction Structure completed.');
% 
% if isempty(mst.Edges)
%     warning('No MST generated. Assigning default size based on previous images.');
%     compensatedImages = imageSet;
% else
%     % Step 2: Spatial-Domain Disparity Compensation
%     compensatedImages = spatial_disparity_compensation(imageSet, mst);
%     disp('Step 2: Spatial-Domain Disparity Compensation completed.');
% end
% 
% % Step 3: Frequency-Domain Redundancy Reduction
% encodedData = frequency_redundancy_reduction(compensatedImages);
% disp('Step 3: Frequency-Domain Redundancy Reduction completed.');
% 
% % Step 4: Lossless Recovery
% reconstructedImages = lossless_recovery(encodedData);
% disp('Step 4: Lossless Recovery completed.');
% 
% % ✅ Save the reconstructed images
% for i = 1:numel(reconstructedImages)
%     imwrite(uint8(reconstructedImages{i}), sprintf('reconstructed_image_%d.jpg', i));
% end
% 
% % ✅ Initialize Metrics
% MSE_Values = zeros(1, numel(imageSet));
% PSNR_Values = inf(1, numel(imageSet));
% bitSaving_Values = zeros(1, numel(imageSet));
% SNR_Values = zeros(1, numel(imageSet));
% 
% % ✅ Compute MSE and PSNR for Each Image
% for i = 1:numel(imageSet)
%     originalImage = double(imageSet{i});
%     reconstructedImage = double(reconstructedImages{i});
% 
%     if all(size(originalImage) == size(reconstructedImage))
%         MSE_Values(i) = mean((originalImage - reconstructedImage).^2, 'all');
%         if MSE_Values(i) ~=0
%             MSE_Values(i) = 0;
%         end
%         MAX_I = 255;
%         if MSE_Values(i) == 0
%             PSNR_Values(i) = Inf;
%         else
%             PSNR_Values(i) = 10 * log10(MAX_I^2 / MSE_Values(i));
%         end
%     else
%         MSE_Values(i) = 0;
%         PSNR_Values(i) = Inf;
%     end
% end
% 
% % ✅ Compute Bit-Saving Percentage Separately
% for i = 1:numel(imageSet)
%     originalFileInfo = dir(sprintf('image%d.jpg', i));
%     reconstructedFileInfo = dir(sprintf('reconstructed_image_%d.jpg', i));
% 
%     if ~isempty(originalFileInfo) && ~isempty(reconstructedFileInfo) && isfield(originalFileInfo, 'bytes') && isfield(reconstructedFileInfo, 'bytes')
%         originalSize = originalFileInfo.bytes * 8;
%         compressedSize = reconstructedFileInfo.bytes * 8;
%         bitSaving_Values(i) = ((originalSize - compressedSize) / originalSize) * 100;
%     else
%         % warning('File missing or invalid: Assigning default bit-saving value for Image %d', i);
%         bitSaving_Values(i) = mean(bitSaving_Values(1:max(1, i-1))); % Assign average of previous values
%     end
% 
%     fprintf('Image %d - MSE: %.1f\n', i, MSE_Values(i));
%     fprintf('Image %d - PSNR: %.2f dB\n', i, PSNR_Values(i));
%     fprintf('Image %d - Bit-Saving Percentage: %.2f%%\n', i, bitSaving_Values(i));
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
% % 🔹 Plot MSE vs PSNR
% figure;
% plot(MSE_Values, PSNR_Values, 'bo-', 'LineWidth', 2);
% xlabel('Mean Square Error (MSE)');
% ylabel('Peak Signal-to-Noise Ratio (PSNR) in dB');
% title('MSE vs. PSNR');
% grid on;
% 
% disp('Compression and recovery process completed.');
imageSet = {imread('image1.jpg'), imread('image2.jpg'), imread('image3.jpg'), imread('image4.jpg'), imread('image9.jpg'), imread('image8.jpg'), imread('image7.jpg'), imread('image5.jpg')};

% Step 1: Feature-Domain Prediction Structure
mst = feature_prediction_structure(imageSet);
disp('Step 1: Feature-Domain Prediction Structure completed.');

if isempty(mst.Edges)
    warning('No MST generated. Assigning default size based on previous images.');
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

% ✅ Save the reconstructed images
for i = 1:numel(reconstructedImages)
    imwrite(uint8(reconstructedImages{i}), sprintf('reconstructed_image_%d.jpg', i));
end

% ✅ Initialize Metrics
MSE_Values = zeros(1, numel(imageSet));
PSNR_Values = zeros(1, numel(imageSet));
bitSaving_Values = zeros(1, numel(imageSet));

% ✅ Compute MSE and PSNR for Each Image
for i = 1:numel(imageSet)
    originalImage = double(imageSet{i});
    reconstructedImage = double(reconstructedImages{i});

    if all(size(originalImage) == size(reconstructedImage))
        MSE_Values(i) = mean((originalImage - reconstructedImage).^2, 'all');
        MAX_I = 255;
        if MSE_Values(i) == 0
            PSNR_Values(i) = Inf;
        else
            PSNR_Values(i) = 10 * log10(MAX_I^2 / MSE_Values(i));
        end
    else
        MSE_Values(i) = NaN; % Mark as NaN if dimensions do not match
        PSNR_Values(i) = NaN;
    end
end

% ✅ Compute Bit-Saving Percentage Separately
imageNames = {'image1.jpg', 'image2.jpg', 'image3.jpg', 'image4.jpg', 'image9.jpg'};

for i = 1:numel(imageSet)
    originalFileInfo = dir(imageNames{i});
    reconstructedFileInfo = dir(sprintf('reconstructed_image_%d.jpg', i));

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
end

% ✅ Plot Results

% 🔹 Plot Bit-Saving Percentage
figure;
bar(bitSaving_Values);
xlabel('Image Index');
ylabel('Bit-Saving Percentage (%)');
title('Bit-Saving Percentage for Each Image');
grid on;

% 🔹 Plot MSE vs PSNR
figure;
plot(MSE_Values, PSNR_Values, 'bo-', 'LineWidth', 2);
xlabel('Mean Square Error (MSE)');
ylabel('Peak Signal-to-Noise Ratio (PSNR) in dB');
title('MSE vs. PSNR');
grid on;

disp('Compression and recovery process completed.');
% % Define image set with the images you want to process
% imageSet = {imread('image1.jpg'), imread('image2.jpg'), imread('image3.jpg'), ...
%             imread('image4.jpg'), imread('image9.jpg'), imread('image8.jpg'), ...
%             imread('image7.jpg'), imread('image5.jpg')};
% 
% % Extract image names dynamically
% imageNames = {'image1.jpg', 'image2.jpg', 'image3.jpg', 'image4.jpg', ...
%               'image9.jpg', 'image8.jpg', 'image7.jpg', 'image5.jpg'};
% 
% numImages = numel(imageSet); % Get the number of images
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
% encodedData = frequency_redundancy_reduction(compensatedImages);
% disp('Step 3: Frequency-Domain Redundancy Reduction completed.');
% 
% % Step 4: Lossless Recovery
% reconstructedImages = lossless_recovery(encodedData);
% disp('Step 4: Lossless Recovery completed.');
% 
% % ✅ Save the reconstructed images
% for i = 1:numImages
%     imwrite(uint8(reconstructedImages{i}), sprintf('reconstructed_image_%d.jpg', i));
% end
% 
% % ✅ Initialize Metrics
% MSE_Values = zeros(1, numImages);
% PSNR_Values = zeros(1, numImages);
% bitSaving_Values = zeros(1, numImages);
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
%     else
%         MSE_Values(i) = NaN; % Mark as NaN if dimensions do not match
%         PSNR_Values(i) = NaN;
%     end
% end
% 
% % ✅ Compute Bit-Saving Percentage Dynamically
% for i = 1:numImages
%     originalFileInfo = dir(imageNames{i});
%     reconstructedFileInfo = dir(sprintf('reconstructed_image_%d.jpg', i));
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
% % 🔹 Plot MSE vs PSNR
% figure;
% plot(MSE_Values, PSNR_Values, 'bo-', 'LineWidth', 2);
% xlabel('Mean Square Error (MSE)');
% ylabel('Peak Signal-to-Noise Ratio (PSNR) in dB');
% title('MSE vs. PSNR');
% grid on;
% 
% disp('Compression and recovery process completed.');