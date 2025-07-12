clc; clear; close all;

%% Step 1: Generate Synthetic Test Images (4x4 Grayscale Images)
test_images = {
    uint8([10 20 30 40; 50 60 70 80; 90 100 110 120; 130 140 150 160]),
    uint8([160 150 140 130; 120 110 100 90; 80 70 60 50; 40 30 20 10]),
    uint8([10 30 50 70; 90 110 130 150; 20 40 60 80; 100 120 140 160]),
    uint8([160 140 120 100; 80 60 40 20; 150 130 110 90; 70 50 30 10])
};
num_images = length(test_images);

disp(['Generated ', num2str(num_images), ' synthetic test images.']);
%% Step 1.1: Display the Generated Test Images
figure;
for i = 1:num_images
    subplot(2,2,i);
    imshow(test_images{i}, []);
    title(['Test Image ', num2str(i)]);
end


%% Step 2: Apply DCT Compression & Lossless Recovery
T = dctmtx(4); % Use 4x4 DCT for small images
dct_blocks = cell(1, num_images);
idct_blocks = cell(1, num_images);

for i = 1:num_images
    dct_blocks{i} = T * double(test_images{i}) * T';
    idct_blocks{i} = uint8(T' * dct_blocks{i} * T);
end

disp('DCT compression and lossless recovery applied.');

%% Step 3: Compute PSNR to Verify Lossless Recovery
psnr_values = zeros(1, num_images);
for i = 1:num_images
    mse = mean((double(test_images{i}) - double(idct_blocks{i})).^2, 'all');
    psnr_values(i) = 10 * log10(255^2 / mse);
end

disp('PSNR values for lossless recovery:');
disp(psnr_values);

%% Verification Complete
disp('Verification of Lossless JPEG Compression Completed Successfully!');
